<template>
  <n-tabs
    default-value="info"
    justify-content="space-evenly"
    type="line"
    z-index="1000"
    bg="white"
    flex="grow-0"
  >
    <n-tab name="info">
      <router-link to="/post/MRTtrans">轉乘資訊</router-link>
    </n-tab>
    <n-tab name="announce">
      <router-link to="/post/MRTcommon">周遭景點</router-link>
    </n-tab>
  </n-tabs>
  <div flex="~ col" h="130" overflow="auto" class="scrollbar-hide" w="full">
    <!-- Header: 選擇出發站點 -->
    <div bg="blue-100" pos="sticky top-0 z-60" space="y-5px" p="x-4 y-3.5">
      <div flex="~ gap-4">
        <div flex="~ gap-5px" w="full">
          <div
            class="flex my-auto p-3px"
            border="2 rounded-lg"
            :style="setLineColor(currentColor)"
          >
            <n-icon v-if="currentColor == ''" m="auto" :size="22"
              ><train
            /></n-icon>
            <div v-else class="w-5 h-5 text-center font-semibold">
              {{ CurrentRoute.value }}
            </div>
          </div>
          <n-select
            v-model:value="CurrentRoute.value"
            :options="routeOpt"
            placeholder="請選擇路線"
            :theme-overrides="selectThemeOverrides()"
          />
        </div>
        <div flex="~ gap-5px" w="full">
          <n-icon v-if="CurrentStation.value == null" m="auto" :size="22">
            <location text="body" />
          </n-icon>
          <div
            class="my-auto !bg-transparent font-medium whitespace-nowrap"
            style="font-size: 16px"
            :style="setLineColor(currentColor)"
            v-else
          >
            {{ CurrentRoute.value
            }}{{ CurrentStation.number?.toString().padStart(2, "0") }}
          </div>
          <n-select
            v-model:value="CurrentStation.value"
            :options="stationOpt"
            placeholder="請選擇站點"
          />
        </div>
      </div>
    </div>
    <router-view />
  </div>
</template>

<script setup lang="ts">
import store from "@/scripts/vuex";
import axios from "axios";
import { NTabs, NTab, NSelect, NCard, NIcon } from "naive-ui";
import { ref, reactive, computed, onBeforeMount, watch } from "vue";
import { Station, Line, LineStation } from "../scripts/types";
import { curry } from "lodash";
import { watchOnce } from "@vueuse/core";
import train from "../assets/icon/iTrain.vue";
import location from "../assets/icon/iLocation.vue";

let currentColor = "";
const AllLine = ref<Line[]>();
const CurrentLineStation = ref<LineStation[]>();
const CurrentRoute = reactive({
  label: "",
  value: null as string | null,
  style: {
    color: "",
  },
});
const CurrentStation = reactive({
  label: "",
  value: null as number | null,
  number: null as number | null,
});
const routeOpt = computed(() =>
  AllLine.value?.map((v, index) => ({
    label: v.name,
    value: v.linecolor,
    style: {
      color: v.colorcode,
    },
  }))
);
const stationOpt = computed(() =>
  CurrentLineStation.value?.map((v, index) => ({
    label: v.station.name,
    value: v.station.id,
    number: v.number,
  }))
);
watch(CurrentRoute, (CurrentRoute) => {
  CurrentStation.value = null;
  //console.log(CurrentRoute);
  updateStationOpt();
});
watch(CurrentStation, () => {
  stationOpt.value?.forEach((v, index) => {
    if (v.value == CurrentStation.value) {
      CurrentStation.number = v.number;
    }
  });
  if (CurrentStation.value != null) {
    //console.log(CurrentLineStation.value[0]);
    const index = CurrentLineStation.value?.findIndex(
      (x) => x.station.id === CurrentStation.value
    );
    if (index != -1) {
      store.dispatch("currentlinestation", CurrentLineStation.value[index]);
    }
  }
});
function updateStationOpt() {
  AllLine.value?.forEach((v, index) => {
    if (v.linecolor == CurrentRoute.value) {
      currentColor = v.colorcode;
      CurrentRoute.style.color = v.colorcode;
    }
  });
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/line_station", {
      params: {
        linecolor: CurrentRoute.value,
      },
    })
    .then(function (response) {
      console.log(response);
      CurrentLineStation.value = response.data.data;
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
function setLineColor(color: string) {
  const textColor = "color: " + color + "; ";
  const borderColor = "border-color: " + color + "; ";
  const bgColor = "background-color: white;";
  if (color == "") return "border-color: transparent; color: #555555;";
  return textColor + borderColor;
}
function selectThemeOverrides() {
  return {
    peers: {
      InternalSelection: {
        textColor: currentColor,
      },
    },
  };
}

onBeforeMount(() => {
  //console.log(CurrentStation.value);
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
  if (store.state.currentlinestation) {
    //console.log(store.state.currentlinestation);
    CurrentRoute.value = store.state.currentlinestation.linecolor;
    updateStationOpt();
    watchOnce(stationOpt, () => {
      CurrentStation.value = store.state.currentlinestation.station.id;
      //console.log(CurrentStation.value);
    });
  }
});
</script>

<style scoped>
::-webkit-scrollbar {
  display: none;
}
</style>
