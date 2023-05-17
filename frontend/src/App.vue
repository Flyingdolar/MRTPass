<template>
  <nav>
    <n-page-header title="捷運通 MRT PASS"></n-page-header>
  </nav>
  <router-view />
  <nav>
    <router-link to="/about">捷運資訊</router-link> |
    <router-link to="/post">捷運周邊</router-link> |
    <router-link to="/post">遺失物</router-link> |
    <router-link to="/post">我的帳號</router-link>
  </nav>
</template>

<script setup lang="ts">
import { NPageHeader } from "naive-ui";
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

nav {
  padding: 30px;
}

nav a {
  font-weight: bold;
  color: #2c3e50;
}

nav a.router-link-exact-active {
  color: #42b983;
}
</style>
