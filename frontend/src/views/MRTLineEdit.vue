<template>
  <div flex="~ col" justify="center items-end" h="10" bg="white">
    <div flex="~" m="t-auto b-10px l-6 r-17" justify="items-center">
      <n-button @click="goback" quaternary>
        <n-icon :size="20"><back /></n-icon>
      </n-button>
      <div
        flex="grow"
        mt="1"
        text="title center bottom"
        style="font-size: 16px"
      >
        捷運路線編輯
      </div>
    </div>
    <div p="y-1pt" bg=" gray-200" />
  </div>
  <div flex="~ col gap-3" h="160" overflow="auto">
    <div py="1.5" />
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
    </n-card>
    <div flex="~ gap-8" class="justify-center px-24 py-4 bg-white">
      <n-button @click="SaveEdit" type="primary" flex="grow" ghost>
        <template #icon>
          <n-icon><save /></n-icon>
        </template>
        <div>儲存</div>
      </n-button>
    </div>
  </div>
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
  NIcon,
  NForm,
  NFormItem,
  NInput,
  NSelect,
  NPopconfirm,
} from "naive-ui";
import back from "../assets/icon/iExpLeft.vue";
import save from "../assets/icon/iSave.vue";
import type { DataTableColumns } from "naive-ui";
import { computed, h, onMounted, ref, watch, reactive } from "vue";
import { watchOnce } from "@vueuse/core";
import { User, Role } from "../scripts/types";
import axios from "axios";
import router from "@/router";
import store from "@/scripts/vuex";
import { useRoute } from "vue-router";
const message = useMessage();
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
      message.info(response.data.message);
      router.push("/linelist");
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
</script>
