<template>
  <n-card class="card">
    <n-space size="large" line-height="20px" vertical w="full">
      <n-space>
        <n-button @click="goback" size="large" justify="start">返回</n-button>
        <n-h3 class="cardtitle" text-align="center">編輯票價</n-h3>
      </n-space>
      <n-space>
        <n-space justify="center" class="content2">
          <n-card :bordered="false" size="huge" role="dialog" aria-modal="true">
            <n-form ref="formRef" :label-width="80">
              <n-form-item label="基本費用"
                ><n-input v-model:value="model.basicprice"></n-input
              ></n-form-item>
              <n-h3>區段設定</n-h3>
              <div v-for="(item, index) in model.length" :key="item">
                <n-form-item :label="`區間${index + 1}`">
                  <n-input-number
                    v-model:value="model.distance[index]"
                    :validator="validator"
                    :show-button="disabled"
                    ><template #prefix> 距離 </template></n-input-number
                  >
                  <n-input-number
                    v-model:value="model.addtionprice[index]"
                    :validator="validator"
                    :show-button="disabled"
                    ><template #prefix> 額外費用 </template></n-input-number
                  >
                </n-form-item>
              </div>
              <n-button @click="addDistance"> 新增區間 </n-button>
              <n-button @click="deleteDistance"> 減少區間 </n-button>
            </n-form>
            <template #footer>
              <n-space vertical>
                <n-button @click="SaveEdit">儲存</n-button>
              </n-space>
            </template>
          </n-card>
        </n-space>
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
  NInputNumber,
} from "naive-ui";
import type { DataTableColumns } from "naive-ui";
import { computed, h, onMounted, ref, watch, reactive } from "vue";
import { watchOnce } from "@vueuse/core";
import { Station, Role, Line, TimeTable } from "../scripts/types";
import axios from "axios";
import router from "@/router";
import { useRoute } from "vue-router";
const disabled = ref(false);
const validator = (x: number) => x >= 0;
const message = useMessage();
const editTimeTablemodal = ref(false);
const route = useRoute();
const model = reactive({
  basicprice: null,
  length: [0],
  distance: [null],
  addtionprice: [null],
});
const AllLine = ref<Line[]>();
const AllTimeTable = ref<TimeTable[]>();
onMounted(() => {
  /*
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/station/" + route.params.id)
    .then(function (response) {
      console.log(response.data.data);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios*/
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
    .patch("http://localhost:3000/api/mrt_admin/station/" + route.params.id, {})
    .then(function (response) {
      message.info(response.data.message);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
function EditStation(id: number) {
  console.log("wait");
}
function DeleteStation(id: number, index: number) {
  //axios delete
  axios
    .delete(
      "http://localhost:3000/api/mrt_admin/station/" +
        route.params.id +
        "/time_table/" +
        (id as unknown as string)
    )
    .then(function (response) {
      console.log(response);
      AllTimeTable.value?.splice(index, 1);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
function EditTimeTable() {
  editTimeTablemodal.value = !editTimeTablemodal.value;
}
function addDistance() {
  model.length.push(0);
  model.distance.push(null);
  model.addtionprice.push(null);
}
function deleteDistance() {
  model.length.pop();
  model.distance.pop();
  model.addtionprice.pop();
}
</script>
