<template>
  <!-- Header -->
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
        編輯票價
      </div>
    </div>
    <div p="y-1pt" bg=" gray-200" />
  </div>
  <div flex="~ col gap-3" h="160" overflow="auto">
    <div py="1" />
    <n-card role="dialog" aria-modal="true" title="費用設定">
      <n-form ref="formRef" :label-width="80">
        <n-form-item label="基本費用"
          ><n-input v-model:value="model.basicprice"></n-input
        ></n-form-item>
      </n-form>
    </n-card>
    <n-card role="dialog" aria-modal="true" title="區段設定">
      <template #header-extra>
        <n-button-group>
          <n-button round @click="addDistance">
            <template #icon>
              <n-icon><add /></n-icon>
            </template>
          </n-button>
          <n-button round @click="deleteDistance">
            <template #icon>
              <n-icon><minus /></n-icon>
            </template>
          </n-button>
        </n-button-group>
      </template>
      <n-form ref="formRef" :label-width="80">
        <div v-for="(item, index) in model.length" :key="item">
          <n-form-item :label="`區間${index + 1}`">
            <div flex="~ gap-6">
              <n-input-number
                v-model:value="model.distance[index]"
                :validator="validator"
                :show-button="disabled"
                placeholder="請輸入距離"
              >
                <template #prefix>
                  <n-icon><distance text="title" /></n-icon>
                  <div pr="2" />
                </template>
              </n-input-number>
              <n-input-number
                v-model:value="model.addtionprice[index]"
                :validator="validator"
                :show-button="disabled"
                placeholder="請輸入金額"
              >
                <template #prefix>
                  <img w="18px" src="../assets/icon/dollar.png" />
                  <div pr="2" />
                </template>
              </n-input-number>
            </div>
          </n-form-item>
        </div>
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
    <div py="1.5" />
  </div>
</template>

<script setup lang="ts">
import {
  NCard,
  NIcon,
  NSpace,
  NButton,
  NButtonGroup,
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
import back from "../assets/icon/iExpLeft.vue";
import distance from "../assets/icon/iLine.vue";
import cancel from "../assets/icon/iRefund.vue";
import save from "../assets/icon/iSave.vue";
import add from "../assets/icon/iAdd.vue";
import minus from "../assets/icon/iMinus.vue";
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
  router.push("/profile");
}
function SaveEdit() {
  //axios patch
  axios
    .patch("http://localhost:3000/api/mrt_admin/station/" + route.params.id, {})
    .then(function (response) {
      message.success("儲存成功");
    })
    .catch(function (error) {
      message.error("儲存失敗，請檢查欄位輸入是否合法");
    });
  //axios
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

<style scoped>
::-webkit-scrollbar {
  display: none;
}
</style>
