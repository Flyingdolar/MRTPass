<template>
  <div class="home">
    <n-button>捷運資訊</n-button>
    <n-button>捷運公告</n-button>
    <router-view />
  </div>
</template>

<script setup lang="ts">
import { NButton } from "naive-ui";
</script>
