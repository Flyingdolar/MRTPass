<template>
  <n-layout flex="~ col" bg="white" h="full">
    <!-- Header -->
    <n-layout-header p="4" bg="white" pos="relative">
      <n-space justify="space-between" :wrap="false">
        <Title />
        <div p="x-2 y-1" border="1 rounded-lg">
          <div text="sm secondary">訪客使用者</div>
        </div>
      </n-space>
    </n-layout-header>
    <!-- Content -->
    <n-layout-content bg="gray-100" class="body">
      <router-view />
    </n-layout-content>
    <!-- Footer -->
    <n-layout-footer flex="~" bg="white" pos="relative">
      <!-- Sec01: 捷運資訊 -->
      <router-link to="/" class="flex-grow" bg="white hover:blue-100">
        <n-space :vertical="true" align="center" p="x-auto y-2" :size="[0, 0]">
          <n-icon size="24">
            <compass />
          </n-icon>
          <div text="secondary xs center" w="12">捷運資訊</div>
        </n-space>
      </router-link>
      <!-- Sec02: 捷運周邊 -->
      <router-link to="/post" class="flex-grow" bg="white hover:blue-100">
        <n-space :vertical="true" align="center" p="x-auto y-2" :size="[0, 0]">
          <n-icon size="24">
            <star />
          </n-icon>
          <div text="secondary xs center" w="12">捷運周邊</div>
        </n-space>
      </router-link>
      <!-- Sec03: 遺失物 -->
      <router-link to="/about" class="flex-grow" bg="white hover:blue-100">
        <n-space :vertical="true" align="center" p="x-auto y-2" :size="[0, 0]">
          <n-icon size="24">
            <bag />
          </n-icon>
          <div text="secondary xs center" w="12">遺失物</div>
        </n-space>
      </router-link>
      <!-- Sec04: 我的帳號 -->
      <router-link to="/account" class="flex-grow" bg="white hover:blue-100">
        <n-space :vertical="true" align="center" p="x-auto y-2" :size="[0, 0]">
          <n-icon size="24">
            <user />
          </n-icon>
          <div text="secondary xs center" w="12">我的帳號</div>
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
} from "naive-ui";
import Title from "/src/assets/appTitle.vue";
import compass from "/src/assets/icon/iCompass.vue";
import star from "/src/assets/icon/iStar.vue";
import bag from "/src/assets/icon/iBag.vue";
import user from "/src/assets/icon/iUser.vue";
import { ref, reactive, computed, onMounted, watch } from "vue";
import { watchOnce } from "@vueuse/core";
import store from "./scripts/vuex";

const isLogin = computed(() => (store?.state?.userinfo ? true : false));
onMounted(() => {
  if (!isLogin.value) {
    fetchsession();
  }
  //console.log(store.state.userinfo);
});
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
