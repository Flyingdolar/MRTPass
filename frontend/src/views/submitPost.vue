<template>
  <n-tabs
    default-value="info"
    justify-content="space-evenly"
    type="line"
    bg="white"
  >
    <n-tab name="info">
      <router-link to="/post/MRTtrans">轉乘資訊</router-link>
    </n-tab>
    <n-tab name="announce">
      <router-link to="/post/MRTcommon">周遭景點</router-link>
    </n-tab>
  </n-tabs>
  <div p="x-4 y-3" space="y-1" bg="blue-100">
    <div text="title">選擇出發站點</div>
    <div flex="~" space="x-4">
      <n-select
        v-model:value="CurrentRoute"
        :options="routeOpt"
        placeholder="請選擇路線"
      />
      <n-select
        v-model:value="CurrentStation"
        :options="stationOpt"
        placeholder="請選擇站點"
      />
    </div>
  </div>
  <router-view />
</template>

<script setup lang="ts">
import store from "@/scripts/vuex";
import axios from "axios";
import { NTabs, NTab, NSelect } from "naive-ui";
import { ref, reactive, computed, onBeforeMount, watch } from "vue";
import { Station, Line, LineStation } from "../scripts/types";
import { curry } from "lodash";
import { watchOnce } from "@vueuse/core";
const AllLine = ref<Line[]>();
const CurrentLineStation = ref<LineStation[]>();
const CurrentRoute = ref<string>();
const CurrentStation = ref<number | null>();
const routeOpt = computed(() =>
  AllLine.value?.map((v, index) => ({
    label: v.name,
    value: v.linecolor,
  }))
);
const stationOpt = computed(() =>
  CurrentLineStation.value?.map((v, index) => ({
    label: v.station.name,
    value: v.station.id,
  }))
);
watch(CurrentRoute, (CurrentRoute) => {
  CurrentStation.value = null;
  //console.log(CurrentRoute);
  updateStationOpt();
});
watch(CurrentStation, () => {
  if (CurrentStation.value != null) {
    //console.log(CurrentLineStation.value[0]);
    const index = CurrentLineStation.value.findIndex(
      (x) => x.station.id === CurrentStation.value
    );
    if (index != -1) {
      store.dispatch("currentlinestation", CurrentLineStation.value[index]);
    }
  }
});
function updateStationOpt() {
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/line_station", {
      params: {
        linecolor: CurrentRoute.value,
      },
    })
    .then(function (response) {
      //console.log(response);
      CurrentLineStation.value = response.data.data;
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
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
