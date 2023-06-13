<template>
  <n-card class="card">
    <div>
      <n-space justify="space-around" size="large" line-height="20px">
        <n-button @click="goback" size="large">返回</n-button>
        <n-h3 class="cardtitle">{{ CurrentCommon?.info.name }}</n-h3>
        <n-button @click="goback" size="large">Option</n-button>
      </n-space>
    </div>
    <n-space
      :header-style="{ 'align-self': 'center' }"
      :footer-style="{ 'align-self': 'center' }"
      justify="center"
      class="content2"
    >
      <n-card
        header-style="padding: 0;"
        footer-style="padding: 0;"
        :bordered="false"
      >
        <template #default>
          <div p="y-2" text="s">{{ CurrentCommon?.info.Des }}</div>
          <div p="y-2" text="xs secondary">
            地點： {{ CurrentCommon?.info.address }}
          </div>
        </template>
        <template #footer>
          <div flex="~" p="x-4 y-2">
            {{ parseFloat(CurrentCommon?.average_score).toFixed(1) }}顆星評價·{{
              CurrentComment?.length
            }}則評論
          </div>
        </template>
      </n-card>
    </n-space>
    <div v-for="item in CurrentComment" :key="item.id">
      <n-card
        :footer-style="{ 'align-self': 'center' }"
        justify="center"
        class="content2"
        :title="item.member_id"
      >
        <template #header-extra> {{ item.score }}顆星評價 </template>
        {{ item.comment }}
        <template #footer>
          {{ itemDate(item.created_at, item.updated_at) }}
        </template>
      </n-card>
    </div>
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
import { Station, Role, Common, Comment } from "../scripts/types";
import axios from "axios";
import router from "@/router";
import store from "@/scripts/vuex";
import { useRoute } from "vue-router";
import { parentPort } from "worker_threads";
const EditUsermodal = ref(false);
const CurrentCommon = ref<Common>();
const CurrentComment = ref<Comment[]>();
const route = useRoute();
function itemDate(create: string, update: string) {
  const date = create == update ? new Date(create) : new Date(update);
  const year = date.getFullYear();
  const month = date.getMonth() + 1;
  const day = date.getDate();
  const hour = date.getHours();
  const minute = date.getMinutes();
  if (create == update) {
    return `發佈於 ${year}.${month}.${day} ${hour}:${minute}`;
  } else {
    return `更新於 ${year}.${month}.${day} ${hour}:${minute}`;
  }
}
onMounted(() => {
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/common/" + route.params.id)
    .then(function (response) {
      //console.log(response);
      CurrentCommon.value = response.data.data;
      console.log(CurrentCommon.value);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios 	/api/member/info/:info_id/comment/:id
  //axios get
  axios
    .get(
      "http://localhost:3000/api/member/info/" + route.params.id + "/comment"
    )
    .then(function (response) {
      console.log(response);
      CurrentComment.value = response.data.data;
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
});

function EditStation(id: number) {
  router.push("/stationlist/" + (id as unknown as string));
}
function DeleteStation(id: number) {
  //axios delete
  axios
    .delete(
      "http://localhost:3000/api/mrt_admin/station/" + (id as unknown as string)
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
  router.push("/post/MRTcommon");
}
function tmp() {
  console.log("Not yet:D");
}
</script>
