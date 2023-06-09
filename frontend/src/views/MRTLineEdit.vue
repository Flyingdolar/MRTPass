<template>
  <n-card class="card">
    <n-space size="large" line-height="20px">
      <n-button @click="goback" size="large">返回</n-button>
      <n-h3 class="cardtitle">編輯路線</n-h3>
    </n-space>
    <n-space justify="center" class="content2">
      <n-card :bordered="false" size="huge" role="dialog" aria-modal="true">
        <n-form ref="formRef" :label-width="80">
          <n-form-item label="路線代號"
            ><n-input v-model:value="model.linecolor"></n-input
          ></n-form-item>
          <n-form-item label="路線名稱"
            ><n-input v-model:value="model.name"></n-input
          ></n-form-item>
          <n-form-item label="路線顏色"
            ><n-input v-model:value="model.colorcode"></n-input
          ></n-form-item>
        </n-form>
        <template #footer>
          <n-space vertical>
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
} from "naive-ui";
import type { DataTableColumns } from "naive-ui";
import { computed, h, onMounted, ref, watch, reactive } from "vue";
import { watchOnce } from "@vueuse/core";
import { User, Role } from "../scripts/types";
import axios from "axios";
import router from "@/router";
import store from "@/scripts/vuex";
import { useRoute } from "vue-router";
const route = useRoute();
const model = reactive({
  id: 0,
  name: "",
  linecolor: "",
  colorcode: "",
});
onMounted(() => {
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/line/" + route.params.id)
    .then(function (response) {
      //console.log(response.data);
      model.colorcode = response.data.data.colorcode;
      model.name = response.data.data.name;
      model.linecolor = response.data.data.linecolor;
      model.id = response.data.data.id;
      //console.log(model);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
});
function goback() {
  router.push("/linelist");
}
function SaveEdit() {
  //axios patch
  axios
    .patch("http://localhost:3000/api/mrt_admin/line/" + route.params.id, {
      name: model.name,
      linecolor: model.linecolor,
      id: model.id,
    })
    .then(function (response) {
      console.log(response);
      router.push("/linelist");
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
</script>
