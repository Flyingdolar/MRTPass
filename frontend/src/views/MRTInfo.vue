<template>
  <!-- Header: 選擇出發站點 -->
  <div p="x-4 y-3" space="y-1" bg="blue-100">
    <div text="title">選擇出發站點</div>
    <div flex="~" space="x-4">
      <n-select
        v-model:value="depRoute.value"
        :options="routeOpt"
        placeholder="請選擇路線"
        text="cool-gray-500"
        :theme-overrides="selectThemeOverrides1()"
      />
      <n-select
        v-model:value="depStation.value"
        :options="depStationOpt"
        placeholder="請選擇站點"
      />
    </div>
  </div>
  <!-- Body: 班次資訊 -->
  <div m="y-2" space="y-2">
    <n-card title="班次資訊">
      <template #header-extra>
        <n-button @click="updateTicketandTime()">刷新資訊</n-button>
      </template>
      <div v-if="timetablesearchResult">
        <div v-for="item in timetablesearchResult" :key="item.No">
          <n-card :title="item.name">
            <template #header-extra>
              {{ item.spend_time }}
            </template>
          </n-card>
        </div>
      </div>
      <div v-if="!timetablesearchResult">查無班次資訊</div>
    </n-card>
    <n-card title="票價查詢">
      <div space="y-2">
        <div space="y-1">
          <div>選擇目的地站點</div>
          <div flex="~" space="x-4">
            <n-select
              v-model:value="arrRoute.value"
              :options="routeOpt"
              placeholder="請選擇路線"
              :theme-overrides="selectThemeOverrides2()"
            />
            <n-select
              v-model:value="arrStation.value"
              :options="arrStationOpt"
              placeholder="請選擇站點"
            />
          </div>
        </div>
        <div space="y-1">
          <div text="sm" v-if="price">價格<br />{{ price }}元</div>
        </div>
        <div space="y-1">
          <div text="sm" v-if="!price">請選擇站點</div>
        </div>
      </div>
    </n-card>
  </div>
</template>

<script setup lang="ts">
import axios from "axios";
import {
  NSelect,
  NForm,
  NInput,
  NFormItem,
  FormRules,
  FormInst,
  NButton,
  NCard,
  FormItemRule,
  SelectProps,
} from "naive-ui";
import { ref, reactive, computed, onMounted, watch, h } from "vue";
import { Station, Line, LineStation, MRTInfo } from "../scripts/types";
let color1 = "#FF0000";
function selectThemeOverrides1() {
  return {
    peers: {
      InternalSelection: {
        textColor: color1,
      },
    },
  };
}
let color2 = "#FF0000";
function selectThemeOverrides2() {
  return {
    peers: {
      InternalSelection: {
        textColor: color2,
      },
    },
  };
}
const AllLine = ref<Line[]>();
const CurrentdepLineStation = ref<LineStation[]>();
const CurrentarrLineStation = ref<LineStation[]>();
let depRoute = reactive({
  label: "",
  value: "",
  style: {
    color: "",
  },
});

let arrRoute = reactive({
  label: "",
  value: "",
  style: {
    color: "",
  },
});

let depStation = reactive({
  label: "",
  value: "",
  style: {
    color: "",
  },
});
let arrStation = reactive({
  label: "",
  value: "",
  style: {
    color: "",
  },
});
let routeOpt = computed(() =>
  AllLine.value?.map((v, index) => ({
    label: v.linecolor + " · " + v.name,
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
      color1 = item.colorcode;
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
      color2 = item.colorcode;
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
