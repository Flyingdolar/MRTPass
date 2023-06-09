<template>
  <n-card class="card">
    <n-space size="large" line-height="20px">
      <n-button @click="goback" size="large" justify="start">返回</n-button>
      <n-h3 class="cardtitle" text-align="center">編輯站點</n-h3>
      <n-space>
        <n-tabs type="line" animated>
          <n-tab-pane name="基本資訊" tab="基本資訊">
            <n-space justify="center" class="content2">
              <n-card
                :bordered="false"
                size="huge"
                role="dialog"
                aria-modal="true"
              >
                <n-form ref="formRef" :label-width="80">
                  <n-form-item label="站點名稱"
                    ><n-input v-model:value="model.name"></n-input
                  ></n-form-item>
                  <n-form-item label="所屬路線"
                    ><n-select
                      v-model:value="model.linecolor"
                      :options="lineOptions"
                    ></n-select
                  ></n-form-item>
                  <n-form-item label="所屬路線編號"
                    ><n-input v-model:value="model.number"></n-input
                  ></n-form-item>
                  <n-form-item label="交叉路線"
                    ><n-select
                      v-model:value="model.linecolor2"
                      :options="lineOptions"
                    ></n-select
                  ></n-form-item>
                  <n-form-item label="交叉路線編號"
                    ><n-input v-model:value="model.number2"></n-input
                  ></n-form-item>
                  <n-form-item label="經度"
                    ><n-input v-model:value="model.y_Pos"></n-input
                  ></n-form-item>
                  <n-form-item label="緯度"
                    ><n-input v-model:value="model.x_Pos"></n-input
                  ></n-form-item>
                  <n-form-item label="站點出口數"
                    ><n-input v-model:value="model.exit_Num"></n-input
                  ></n-form-item>
                </n-form>
                <template #footer>
                  <n-space vertical>
                    <n-button @click="SaveEdit">儲存</n-button>
                  </n-space>
                </template>
              </n-card>
            </n-space>
          </n-tab-pane>
          <n-tab-pane name="班次列表" tab="班次列表"> 路線 is here </n-tab-pane>
        </n-tabs>
      </n-space>
    </n-space>
  </n-card>
</template>

<script setup lang="ts">
import {
  NCard,
  NSpace,
  NButton,
  NModal,
  NDataTable,
  useMessage,
  NH3,
  NForm,
  NFormItem,
  NInput,
  NSelect,
  NPopconfirm,
  NTabs,
  NTabPane,
} from "naive-ui";
import type { DataTableColumns } from "naive-ui";
import { computed, h, onMounted, ref, watch, reactive } from "vue";
import { watchOnce } from "@vueuse/core";
import { Station, Role, Line } from "../scripts/types";
import axios from "axios";
import router from "@/router";
import { useRoute } from "vue-router";
const route = useRoute();
const model = reactive({
  exit_Num: 0,
  id: 0,
  name: "",
  x_Pos: 0,
  y_Pos: 0,
  number: 0,
  linecolor: "",
  linename: "",
  number2: "",
  linecolor2: "",
  linename2: "",
});
const AllLine = ref<Line[]>();
onMounted(() => {
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/station/" + route.params.id)
    .then(function (response) {
      //console.log(response.data.data.station);
      //console.log(response.data.data.stationno);
      model.exit_Num = response.data.data.station.exit_Num;
      model.id = response.data.data.station.id;
      model.name = response.data.data.station.name;
      model.x_Pos = response.data.data.station.x_Pos;
      model.y_Pos = response.data.data.station.y_Pos;
      model.number = response.data.data.stationno[0].stationno.number;
      model.linecolor = response.data.data.stationno[0].stationno.linecolor;
      model.linename = response.data.data.stationno[0].linename;
      if (response.data.data.stationno.length == 2) {
        model.number2 = response.data.data.stationno[1].stationno.number;
        model.linecolor2 = response.data.data.stationno[1].stationno.linecolor;
        model.linename2 = response.data.data.stationno[1].linename;
      }
      //console.log(model);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/line")
    .then(function (response) {
      //console.log(response.data.data);
      AllLine.value = response.data.data;
      //console.log(AllLine.value);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
});
const lineOptions = computed(() =>
  AllLine.value?.map((v, index) => ({
    label: v.linecolor + v.name,
    value: v.linecolor,
  }))
);
function goback() {
  router.push("/stationlist");
}
function SaveEdit() {
  //axios patch
  axios
    .patch("http://localhost:3000/api/mrt_admin/station/" + route.params.id, {
      name: model.name,
      linecolor_1: model.linecolor,
      number_1: model.number,
      x_Pos: model.x_Pos,
      y_Pos: model.y_Pos,
      linecolor_2: model.linecolor2,
      number_2: model.number2,
      exit_Num: model.exit_Num,
    })
    .then(function (response) {
      console.log(response);
      router.push("/stationlist");
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
</script>
