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
        捷運路線
      </div>
      <n-button @click="tmp" quaternary>
        <n-icon :size="20"><search /></n-icon>
      </n-button>
    </div>
    <div p="y-1pt" bg=" gray-200" />
  </div>
  <div flex="~ col gap-3" h="160" overflow="auto">
    <div py="3px" />
    <div v-for="line in colData" :key="line.id" bg="white">
      <div flex="~" m="x-6 y-5" justify="items-center">
        <div
          flex="~ grow gap-4"
          m="y-auto l-4"
          text="body"
          justify="items-center"
        >
          <div
            w="8"
            border="2 rounded-lg opacity-20"
            :style="setLineColor(line.colorcode)"
          >
            <div text="center">{{ line.linecolor }}</div>
          </div>
          <div>{{ line.name }}</div>
        </div>
        <div flex="~ gap-6">
          <n-button ghost @click="DeleteLine(line.id)">
            <template #icon>
              <n-icon text="danger"><remove /></n-icon>
            </template>
          </n-button>
          <n-button quaternary @click="EditLine(line.id)">
            <template #icon>
              <n-icon><goto /></n-icon>
            </template>
          </n-button>
        </div>
      </div>
    </div>
    <div py="3px" />
  </div>
</template>

<script setup lang="ts">
import {
  NCard,
  NIcon,
  NSpace,
  NButton,
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
import type { DataTableColumns } from "naive-ui";
import { computed, h, onMounted, ref, watch } from "vue";
import { watchOnce } from "@vueuse/core";
import { Line, Role } from "../scripts/types";
import axios from "axios";
import router from "@/router";
import store from "@/scripts/vuex";
const EditUsermodal = ref(false);
const colData = ref<Line[]>([]);
onMounted(() => {
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/line")
    .then(function (response) {
      console.log(response);
      colData.value = response.data.data.map(function (item, index, array) {
        return {
          id: item.id,
          name: item.name,
          linecolor: item.linecolor,
          colorcode: item.colorcode,
        };
      });
      //console.log(colData.value);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
});

function setLineColor(color: string) {
  return "color: " + color + "; border-color: " + color + ";";
}

function EditLine(id: number) {
  router.push("/linelist/" + (id as unknown as string));
}
function DeleteLine(id: number) {
  //axios delete
  axios
    .delete(
      "http://localhost:3000/api/mrt_admin/line/" + (id as unknown as string)
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
function goback() {
  router.push("/profile");
}
</script>

<style scoped>
::-webkit-scrollbar {
  display: none;
}
</style>
