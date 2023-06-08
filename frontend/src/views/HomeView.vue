<template>
  <!-- 頁面選項 Tab -->
  <n-tabs justify-content="space-evenly" type="line" bg="white">
    <n-tab name="info">
      <router-link to="/MRTInfo">捷運資訊</router-link>
    </n-tab>
    <n-tab name="announce">
      <router-link to="/MRTAnnounce">捷運公告</router-link>
    </n-tab>
  </n-tabs>
  <router-view />
</template>

<script setup lang="ts">
import { NTabs, NTab } from "naive-ui";
</script>
