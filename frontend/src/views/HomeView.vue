<template>
  <!-- 頁面選項 Tab -->
  <n-tabs
    default-value="info"
    justify-content="space-evenly"
    type="line"
    z-index="1000"
    bg="white"
    flex="grow-0"
  >
    <n-tab name="info">
      <router-link to="/MRTInfo">捷運資訊</router-link>
    </n-tab>
    <n-tab name="announce">
      <router-link to="/MRTAnnounce">捷運公告</router-link>
    </n-tab>
  </n-tabs>
  <div flex="~ col" h="159" overflow="auto" class="scrollbar-hide" w="full">
    <!-- 頁面內容 -->
    <router-view />
  </div>
</template>

<script setup lang="ts">
import { NTabs, NTab } from "naive-ui";
</script>

<style scoped>
::-webkit-scrollbar {
  display: none;
}
</style>
