<template>
  <!-- Header: 選擇出發站點 -->
  <n-card bg="blue-100" title="選擇站點" pos="sticky -top-15 z-60">
    <div space="y-5px" mx="1">
      <div text="body">出發站點</div>
      <div flex="~ gap-4">
        <div flex="~ gap-5px" w="full">
          <div
            class="flex my-auto p-3px"
            border="2 rounded-lg"
            :style="setLineColor(depColor)"
          >
            <n-icon v-if="depColor == ''" m="auto" :size="22"><train /></n-icon>
            <div v-else class="w-5 h-5 text-center font-semibold">
              {{ depRoute.value }}
            </div>
          </div>
          <n-select
            v-model:value="depRoute.value"
            :options="routeOpt"
            placeholder="請選擇路線"
            :theme-overrides="selectThemeOverrides1()"
          />
        </div>
        <div flex="~ gap-5px" w="full">
          <div class="flex my-auto p-3px">
            <n-icon m="auto" :size="22">
              <location text="body" />
            </n-icon>
          </div>
          <n-select
            v-model:value="depStation.value"
            :options="depStationOpt"
            placeholder="請選擇站點"
          />
        </div>
      </div>
      <div p="1" />
      <div text="body">目的地站點</div>
      <div flex="~ gap-4">
        <div flex="~ gap-5px" w="full">
          <div
            class="flex my-auto p-3px"
            border="2 rounded-lg"
            :style="setLineColor(arrColor)"
          >
            <n-icon v-if="arrColor == ''" m="auto" :size="22"><train /></n-icon>
            <div v-else class="w-5 h-5 text-center font-semibold">
              {{ arrRoute.value }}
            </div>
          </div>
          <n-select
            v-model:value="arrRoute.value"
            :options="routeOpt"
            placeholder="請選擇路線"
            :theme-overrides="selectThemeOverrides2()"
          />
        </div>
        <div flex="~ gap-5px" w="full">
          <div class="flex my-auto p-3px">
            <n-icon m="auto" :size="22">
              <location text="body" />
            </n-icon>
          </div>
          <n-select
            v-model:value="arrStation.value"
            :options="arrStationOpt"
            placeholder="請選擇站點"
          />
        </div>
      </div>
    </div>
  </n-card>
  <!-- Body: 班次資訊 -->
  <div m="y-2" space="y-2">
    <n-card title="班次資訊">
      <template #header-extra>
        <n-button
          @click="updateTicketandTime()"
          type="tertiary"
          size="small"
          class="mt-0.5"
          ghost
        >
          <template #icon>
            <n-icon :size="16"><refresh /></n-icon>
          </template>
          <div text="sm">刷新</div>
        </n-button>
      </template>
      <div v-if="timetablesearchResult">
        <div v-for="item in timetablesearchResult" :key="item.No">
          <n-card :title="item.name">
            <template #header>
              <div flex="~ gap-4">
                <div
                  class="flex my-auto p-3px"
                  border="2 rounded-lg"
                  :style="getLineColor(item.line)"
                >
                  <div class="w-8 text-center font-semibold">
                    {{ item.line }}
                  </div>
                </div>
                <div my="auto">{{ item.name }}</div>
              </div>
            </template>
            <template #header-extra>
              <div class="tracking-widest">{{ item.spend_time }}</div>
            </template>
          </n-card>
        </div>
      </div>
      <div v-if="!timetablesearchResult">查無班次資訊</div>
    </n-card>
    <n-card title="票價查詢">
      <div p="b-2">價格</div>
      <div v-if="price" flex="~ gap-3" mx="2">
        <n-icon my="auto" :size="18"><money /></n-icon>
        <div my="auto" text="xl title">{{ price }}</div>
      </div>
      <div v-else>
        <div my="auto" text="secondary">（請選擇路線與站點）</div>
      </div>
    </n-card>
  </div>
</template>

<script setup lang="ts">
import axios from "axios";
import { NSelect, NButton, NCard, NIcon } from "naive-ui";
import { ref, reactive, computed, onMounted, watch, h } from "vue";
import { Station, Line, LineStation, MRTInfo } from "../scripts/types";
import train from "../assets/icon/iTrain.vue";
import location from "../assets/icon/iLocation.vue";
import refresh from "../assets/icon/iRefresh.vue";
import money from "../assets/icon/iMoney.vue";

let depColor = "";
let arrColor = "";
function selectThemeOverrides1() {
  return {
    peers: {
      InternalSelection: {
        textColor: depColor,
      },
    },
  };
}
function selectThemeOverrides2() {
  return {
    peers: {
      InternalSelection: {
        textColor: arrColor,
      },
    },
  };
}
const AllLine = ref<Line[]>();
const CurrentdepLineStation = ref<LineStation[]>();
const CurrentarrLineStation = ref<LineStation[]>();
let depRoute = reactive({
  label: "",
  value: null,
  style: {
    color: "",
  },
});

let arrRoute = reactive({
  label: "",
  value: null,
  style: {
    color: "",
  },
});

let depStation = reactive({
  label: "",
  value: null,
  style: {
    color: "",
  },
});
let arrStation = reactive({
  label: "",
  value: null,
  style: {
    color: "",
  },
});
let routeOpt = computed(() =>
  AllLine.value?.map((v, index) => ({
    label: v.name,
    value: v.linecolor,
    style: {
      color: v.colorcode,
    },
  }))
);
let depStationOpt = computed(() =>
  CurrentdepLineStation.value?.map((v, index) => ({
    label: v.station.name,
    value: v.station.id,
  }))
);
let arrStationOpt = computed(() =>
  CurrentarrLineStation.value?.map((v, index) => ({
    label: v.station.name,
    value: v.station.id,
  }))
);
watch(depRoute, (depRoute) => {
  depStation.value = null;
  price.value = null;
  timetablesearchResult.value = null;
  const index = AllLine.value?.forEach(function (item, index, array) {
    if (item.linecolor == depRoute.value) {
      depColor = item.colorcode;
    }
  });
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/line_station", {
      params: {
        linecolor: depRoute.value,
      },
    })
    .then(function (response) {
      //console.log(response);
      CurrentdepLineStation.value = response.data.data;
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
});
watch(arrRoute, (arrRoute) => {
  arrStation.value = null;
  price.value = null;
  timetablesearchResult.value = null;
  const index = AllLine.value?.forEach(function (item, index, array) {
    if (item.linecolor == arrRoute.value) {
      arrColor = item.colorcode;
    }
  });
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/line_station", {
      params: {
        linecolor: arrRoute.value,
      },
    })
    .then(function (response) {
      //console.log(response);
      CurrentarrLineStation.value = response.data.data;
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
});
const price = ref();
const timetablesearchResult = ref<MRTInfo>();
watch(arrStation, () => {
  updateTicketandTime();
});
watch(depStation, () => {
  updateTicketandTime();
});

function updateTicketandTime() {
  if (arrStation.value && depStation.value) {
    //axios get
    axios
      .get("http://localhost:3000/api/mrt_admin/price_search", {
        params: {
          station1: depStation.value,
          station2: arrStation.value,
        },
      })
      .then(function (response) {
        console.log(response);
        price.value = response.data.data;
      })
      .catch(function (error) {
        console.log(error);
      });
    //axios
    //axios get
    axios
      .get(
        "http://localhost:3000/api/mrt_admin/station/" +
          depStation.value +
          "/time_table_search"
      )
      .then(function (response) {
        console.log(response);
        timetablesearchResult.value = response.data.data;
      })
      .catch(function (error) {
        console.log(error);
      });
  }
}

function getLineColor(line: string) {
  AllLine.value?.forEach(function (item, index, array) {
    if (item.linecolor == line) {
      const color = item.colorcode;
      // console.log(color);
      return "color: " + color + "; " + "border-color: " + color + ";";
    }
  });
  return "";
}

function setLineColor(color: string) {
  const textColor = "color: " + color + "; ";
  const borderColor = "border-color: " + color + "; ";
  const bgColor = "background-color: white;";
  if (color == "") return "border-color: transparent; color: #555555;";
  return textColor + borderColor;
}

onMounted(() => {
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/line")
    .then(function (response) {
      //console.log(response.data.data);
      AllLine.value = response.data.data;
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
});
// Get Route Optiona
</script>
