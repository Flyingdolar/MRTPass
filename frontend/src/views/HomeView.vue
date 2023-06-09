<template>
  <n-space justify="center">
    <n-tabs type="line" animated>
      <n-tab-pane name="捷運資訊" tab="捷運資訊"> <MRTInfo /> </n-tab-pane>
      <n-tab-pane name="捷運公告" tab="捷運公告">
        <MRTAnnounce />
      </n-tab-pane>
    </n-tabs>
  </n-space>
</template>

<script setup lang="ts">
import router from "@/router";
import { NButton, NTabs, NTabPane, NSpace, NCard } from "naive-ui";
import MRTInfo from "../views/MRTInfo.vue";
import MRTAnnounce from "../views/MRTAnnounce.vue";
</script>
