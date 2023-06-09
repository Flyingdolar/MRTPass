<template>
  <n-card class="card">
    <n-space justify="space-around" size="large" line-height="20px">
      <n-button @click="goback" size="large">返回</n-button>
      <n-h3 class="cardtitle">捷運路線</n-h3>
      <n-button @click="tmp" size="large">搜尋</n-button>
    </n-space>
    <n-space justify="center" class="content2">
      <n-card
        :header-style="{ 'align-self': 'center' }"
        :footer-style="{ 'align-self': 'center' }"
        justify="center"
      >
        <div v-for="item in colData" :key="item?.id">
          <n-card>
            <n-space align="start" size="large">
              <n-h3>{{ item.name }}</n-h3>
              <n-space align="end" size="large">
                <n-button @click="EditLine(item.id)">編輯</n-button
                ><n-popconfirm @positive-click="DeleteLine(item.id)"
                  ><template #trigger><n-button>刪除</n-button></template
                  >確認刪除</n-popconfirm
                >
              </n-space>
            </n-space>
          </n-card>
        </div>
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
  NPopconfirm,
} from "naive-ui";
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
      //console.log(response);
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
