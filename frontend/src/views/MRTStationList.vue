<template>
  <div flex="~ col" justify="center items-end" h="10" bg="white">
    <div flex="~" m="t-auto b-10px x-6" justify="items-center">
      <n-button @click="goback" quaternary>
        <n-icon :size="20"><back /></n-icon>
      </n-button>
      <div
        flex="grow"
        mt="1"
        text="title center bottom"
        style="font-size: 16px"
      >
        捷運站點
      </div>
      <n-button @click="tmp" quaternary>
        <n-icon :size="20"><search /></n-icon>
      </n-button>
    </div>
    <div p="y-1pt" bg=" gray-200" />
  </div>
  <div flex="~ col gap-3" h="160" overflow="auto">
    <div py="3px" />
    <div v-for="station in colData" :key="station.id" bg="white">
      <div flex="~" m="x-6 y-5" justify="items-center">
        <div
          flex="~ grow gap-4"
          m="y-auto l-4"
          text="body"
          justify="items-center"
        >
          <div>{{ station.name }}</div>
        </div>
        <div flex="~ gap-6">
          <n-button ghost @click="openDelete(station.id)">
            <template #icon>
              <n-icon text="danger"><remove /></n-icon>
            </template>
          </n-button>
          <n-button quaternary @click="EditStation(station.id)">
            <template #icon>
              <n-icon><goto /></n-icon>
            </template>
          </n-button>
        </div>
      </div>
    </div>
    <div py="3px" />
  </div>
  <!-- Overlay: Confirm Delete -->
  <n-modal v-model:show="showDelete">
    <n-card
      w="3/4 min-30"
      title="確定要刪除？"
      :header-style="{ 'align-self': 'center' }"
    >
      <div text="sm center secondary" pb="2">請注意，刪除後無法復原</div>
      <template #footer>
        <div flex="~ gap-8" class="justify-center px-2">
          <n-button type="error" flex="grow" ghost @click="DeleteStation">
            <template #icon>
              <n-icon :size="18"><remove /></n-icon>
            </template>
            <div>刪除</div>
          </n-button>
          <n-button
            @click="showDelete = false"
            type="tertiary"
            flex="grow"
            ghost
          >
            <template #icon>
              <n-icon :size="18"><cancel /></n-icon>
            </template>
            <div>取消</div>
          </n-button>
        </div>
      </template>
    </n-card>
  </n-modal>
</template>

<script setup lang="ts">
import {
  NCard,
  NSpace,
  NButton,
  NIcon,
  NModal,
  NDataTable,
  useMessage,
  NH3,
  NPopconfirm,
} from "naive-ui";
import back from "../assets/icon/iExpLeft.vue";
import goto from "../assets/icon/iExpRight.vue";
import remove from "../assets/icon/iTrash.vue";
import search from "../assets/icon/iSearch.vue";
import cancel from "../assets/icon/iRefund.vue";
import type { DataTableColumns } from "naive-ui";
import { computed, h, onMounted, ref, watch } from "vue";
import { watchOnce } from "@vueuse/core";
import { Station, Role } from "../scripts/types";
import axios from "axios";
import router from "@/router";
import store from "@/scripts/vuex";

const EditUsermodal = ref(false);
const colData = ref<Station[]>([]);
const showDelete = ref(false);
const selectID = ref(0);

onMounted(() => {
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/station")
    .then(function (response) {
      // console.log(response);
      colData.value = response.data.data.map(function (item, index, array) {
        return {
          id: item.id,
          name: item.name,
        };
      });
      //console.log(colData.value);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
});

function EditStation(id: number) {
  router.push("/stationlist/" + (id as unknown as string));
}
function DeleteStation() {
  //axios delete
  axios
    .delete(
      "http://localhost:3000/api/mrt_admin/station/" +
        (selectID as unknown as string)
    )
    .then(function (response) {
      console.log(response);
      router.go(0);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
function openDelete(id: number) {
  showDelete.value = true;
  selectID.value = id;
}

function goback() {
  router.push("/profile");
}
function tmp() {
  console.log("Not yet:D");
}
</script>

<style scoped>
::-webkit-scrollbar {
  display: none;
}
</style>
