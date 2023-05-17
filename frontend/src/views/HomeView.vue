<template>
  <div class="home">
    <img alt="Vue logo" src="../assets/logo.png" />
    <div><NButton type="primary">Naive Button</NButton></div>
    <HelloWorld msg="Welcome to Your Vue.js + TypeScript App" />
  </div>
</template>

<script setup lang="ts">
import HelloWorld from "@/components/HelloWorld.vue";
import { NButton } from "naive-ui";
</script>
