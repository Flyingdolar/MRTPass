<template>
  <div class="home">
    <nav>
      <n-button><router-link to="/">捷運資訊</router-link></n-button>
      <n-button><router-link to="/MRTAnnounce">捷運公告</router-link></n-button>
    </nav>
    <router-view />
  </div>
</template>

<script setup lang="ts">
import router from "@/router";
import { NButton } from "naive-ui";
</script>
