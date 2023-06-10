<template>
  <!-- Header: 選擇出發站點 -->
  <div p="x-4 y-3" space="y-1" bg="blue-100">
    <div text="title">選擇出發站點</div>
    <div flex="~" space="x-4">
      <n-select
        v-model:value="depRoute.value"
        :options="routeOpt"
        placeholder="請選擇路線"
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
    <n-card title="班次資訊"> Content </n-card>
    <n-card title="票價查詢">
      <div space="y-2">
        <div space="y-1">
          <div>選擇目的地站點</div>
          <div flex="~" space="x-4">
            <n-select
              v-model:value="arrRoute.value"
              :options="routeOpt"
              placeholder="請選擇路線"
            />
            <n-select
              v-model:value="arrStation.value"
              :options="arrStationOpt"
              placeholder="請選擇站點"
            />
          </div>
        </div>
        <div space="y-1">
          <div>價格</div>
          <div text="sm">40 元</div>
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
} from "naive-ui";
import { ref, reactive, computed, onMounted, watch } from "vue";
import { Station, Line, LineStation } from "../scripts/types";
const AllLine = ref<Line[]>();
const CurrentdepLineStation = ref<LineStation[]>();
const CurrentarrLineStation = ref<LineStation[]>();
let depRoute = reactive({
  label: "",
  value: "",
});
let depStation = reactive({
  label: "",
  value: "",
});
let arrRoute = reactive({
  label: "",
  value: "",
});
let arrStation = reactive({
  label: "",
  value: "",
});
let routeOpt = computed(() =>
  AllLine.value?.map((v, index) => ({
    label: v.name,
    value: v.linecolor,
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
let stationOpt = reactive([
  // FIXME: 站點資料應該改為後端抓取
  { label: "象山", value: "2" },
  { label: "台北101/世貿", value: "3" },
  { label: "信義安和", value: "4" },
  { label: "大安", value: "5" },
  { label: "忠孝復興", value: "6" },
  { label: "南京復興", value: "7" },
  { label: "中山國中", value: "8" },
  { label: "松山機場", value: "9" },
  { label: "大直", value: "10" },
  { label: "劍南路", value: "11" },
  { label: "西湖", value: "12" },
  { label: "港墘", value: "13" },
  { label: "文德", value: "14" },
  { label: "內湖", value: "15" },
  { label: "大湖公園", value: "16" },
  { label: "葫洲", value: "17" },
  { label: "東湖", value: "18" },
  { label: "南港軟體園區", value: "19" },
  { label: "南港展覽館", value: "20" },
  { label: "小碧潭", value: "21" },
  { label: "新北投", value: "22" },
  { label: "復興崗", value: "23" },
  { label: "忠義", value: "24" },
  { label: "關渡", value: "25" },
  { label: "竹圍", value: "26" },
  { label: "紅樹林", value: "27" },
  { label: "淡水", value: "28" },
]);
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
