<template>
  <n-layout flex="~ col" bg="white">
    <!-- Header -->
    <n-layout-header p="4" bg="white" pos="relative">
      <n-space justify="space-between" :wrap="false">
        <Title />
        <div p="x-2 y-1" border="1 rounded-lg opacity-30" :class="userColor">
          <div text="sm">{{ userRole }}</div>
        </div>
      </n-space>
    </n-layout-header>
    <!-- Content -->
    <n-layout-content bg="gray-100" class="body">
      <n-message-provider>
        <router-view />
      </n-message-provider>
    </n-layout-content>
    <!-- Footer -->
    <n-layout-footer flex="~" bg="white" pos="relative">
      <!-- Sec01: 捷運資訊 -->
      <router-link to="/MRTInfo" @click="setBtn(1)" flex="grow">
        <n-space
          align="center"
          class="px-auto py-2 hover:bg-blue-100"
          :vertical="true"
          :size="[0, 0]"
          :bg="isActive(1) ? 'blue-50' : 'white'"
          :text="isActive(1) ? 'blue' : 'body'"
          :border="isActive(1) ? 't-2 blue opacity-60' : 't-2 transparent'"
        >
          <n-icon size="24">
            <compass />
          </n-icon>
          <div text="xs center" w="12">捷運資訊</div>
        </n-space>
      </router-link>
      <!-- Sec02: 捷運周邊 -->
      <router-link to="/post" @click="setBtn(2)" flex="grow">
        <n-space
          :vertical="true"
          align="center"
          class="px-auto py-2 hover:bg-blue-100"
          :size="[0, 0]"
          :bg="isActive(2) ? 'blue-50' : 'white'"
          :text="isActive(2) ? 'blue' : 'body'"
          :border="isActive(2) ? 't-2 blue opacity-60' : 't-2 transparent'"
        >
          <n-icon size="24">
            <star />
          </n-icon>
          <div text="xs center" w="12">捷運周邊</div>
        </n-space>
      </router-link>
      <!-- Sec03: 遺失物 -->
      <router-link to="/about" @click="setBtn(3)" flex="grow">
        <n-space
          :vertical="true"
          align="center"
          class="px-auto py-2 hover:bg-blue-100"
          :size="[0, 0]"
          :bg="isActive(3) ? 'blue-50' : 'white'"
          :text="isActive(3) ? 'blue' : 'body'"
          :border="isActive(3) ? 't-2 blue opacity-60' : 't-2 transparent'"
        >
          <n-icon size="24">
            <bag />
          </n-icon>
          <div text="xs center" w="12">遺失物</div>
        </n-space>
      </router-link>
      <!-- Sec04: 我的帳號 -->
      <router-link to="/account" @click="setBtn(4)" flex="grow">
        <n-space
          :vertical="true"
          align="center"
          class="px-auto py-2 hover:bg-blue-100"
          :size="[0, 0]"
          :bg="isActive(4) ? 'blue-50' : 'white'"
          :text="isActive(4) ? 'blue' : 'body'"
          :border="isActive(4) ? 't-2 blue opacity-60' : 't-2 transparent'"
        >
          <n-icon size="24">
            <user />
          </n-icon>
          <div text="xs center" w="12">我的帳號</div>
        </n-space>
      </router-link>
    </n-layout-footer>
  </n-layout>
</template>

<script setup lang="ts">
import router from "@/router";
import axios from "axios";
import {
  NIcon,
  NSpace,
  NLayout,
  NAvatar,
  NLayoutHeader,
  NLayoutContent,
  NLayoutFooter,
  NMessageProvider,
} from "naive-ui";
import Title from "/src/assets/appTitle.vue";
import compass from "/src/assets/icon/iCompass.vue";
import star from "/src/assets/icon/iStar.vue";
import bag from "/src/assets/icon/iBag.vue";
import user from "/src/assets/icon/iUser.vue";
import { ref, reactive, computed, onBeforeMount, watch } from "vue";
import { watchOnce } from "@vueuse/core";
import store from "./scripts/vuex";

const activeBtn = ref(1);
const userColor = computed(() => {
  const role = store.state?.userinfo?.role as unknown as string;
  if (role == "admin") {
    return "text-red border-red";
  } else if (role == "mrt_admin") {
    return "text-orange border-orange";
  } else if (role == "user") return "text-blue border-blue";
  else return "text-secondary border-gray-600";
});
const userRole = computed(() => {
  const role = store.state?.userinfo?.role as unknown as string;
  if (role == "admin") {
    return "系統管理員";
  } else if (role == "mrt_admin") {
    return "捷運管理員";
  } else if (role == "user") return "一般使用者";
  else return "未登入訪客";
});

function setBtn(num: number) {
  activeBtn.value = num;
}

function isActive(num: number) {
  if (num == activeBtn.value) {
    return true;
  } else {
    return false;
  }
}

function fetchsession() {
  //axios get
  axios
    .get("http://localhost:3000/session")
    .then(function (response) {
      //console.log(response.data.data);
      if (response.data.data.isLogin) {
        //console.log(response.data.data.member);
        store.dispatch("userinfo", response.data.data.member);
        //console.log(store.state.userinfo);
      }
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
</script>

<style scoped>
.body {
  height: calc(100vh - 64px - 64px);
}
</style>
