<template>
  <n-card class="card">
    <n-space size="large" line-height="20px">
      <n-button @click="goback" size="large">返回</n-button>
      <n-h3 class="cardtitle">使用者資訊設定</n-h3>
    </n-space>
    <n-space justify="center" class="content2">
      <n-card :bordered="false" size="huge" role="dialog" aria-modal="true">
        <n-form ref="formRef" :label-width="80">
          <n-form-item label="站點名稱"
            ><n-input v-model:value="model.name"></n-input
          ></n-form-item>
          <n-form-item label="所屬路線"
            ><n-input v-model:value="model.linecolor"></n-input
          ></n-form-item>
          <n-form-item label="所屬路線編號"
            ><n-input v-model="model.number"></n-input
          ></n-form-item>
          <n-form-item label="站點出口數"
            ><n-input v-model="model.exit_Num"></n-input
          ></n-form-item>
          <n-form-item label="設定權限"
            ><n-select
              v-model:value="model.id"
              :options="roleOptions"
            ></n-select
          ></n-form-item>
        </n-form>
        <template #footer>
          <n-space vertical>
            <n-popconfirm @positive-click="handlePositiveClick()"
              ><template #trigger><n-button>刪除</n-button></template
              >確認刪除帳號</n-popconfirm
            >
            <n-button @click="SaveEdit">儲存</n-button>
          </n-space>
        </template>
      </n-card>
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
  c,
} from "naive-ui";
import type { DataTableColumns } from "naive-ui";
import { computed, h, onMounted, ref, watch, reactive } from "vue";
import { watchOnce } from "@vueuse/core";
import { Station, Role } from "../scripts/types";
import axios from "axios";
import router from "@/router";
import { useRoute } from "vue-router";
const route = useRoute();
let model = reactive({
  exit_Num: 0,
  id: 0,
  name: "",
  x_Pos: 0,
  y_Pos: 0,
  number: 0,
  linecolor: "",
});
onMounted(() => {
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/station/" + route.params.id)
    .then(function (response) {
      console.log(response.data.data.station);
      console.log(response.data.data.stationno.number);
      model.exit_Num = response.data.data.station.exit_Num;
      model.id = response.data.data.station.id;
      model.name = response.data.data.station.name;
      model.x_Pos = response.data.data.station.x_Pos;
      model.y_Pos = response.data.data.station.y_Pos;
      model.number = response.data.data.stationno.number;
      model.linecolor = response.data.data.stationno.linecolor;
      console.log(model);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
});
const roleOptions = computed(() =>
  [Role[0], Role[1]].map((v, index) => ({
    label: Role[index],
    value: Role[index],
  }))
);
function goback() {
  console.log("hi");
  router.push("/stationlist");
}
function SaveEdit() {
  console.log(model);
  //axios patch
  axios
    .patch(
      "http://localhost:3000/api/admin/authorization/" +
        (model.id as unknown as string),
      {
        name: model?.name,
        id: model?.id,
        exit_num: model.exit_Num,
      }
    )
    .then(function (response) {
      console.log(response);
      router.push("/memberlist");
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
function handlePositiveClick() {
  deleteAccount();
}
function deleteAccount() {
  console.log(model);
  //axios delete
  axios
    .delete(
      "http://localhost:3000/api/admin/authorization/" +
        (model.id as unknown as string)
    )
    .then(function (response) {
      console.log(response);
      router.push("/memberlist");
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
</script>
