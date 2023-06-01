<template>
  <nav>
    <n-page-header title="捷運通 MRT PASS"></n-page-header>
  </nav>
  <router-view />
  <nav>
    <router-link to="/">捷運資訊</router-link> |
    <router-link to="/post">捷運周邊</router-link> |
    <router-link to="/about">遺失物</router-link> |
    <router-link to="/account">我的帳號</router-link>
  </nav>
</template>

<script setup lang="ts">
import router from "@/router";
import axios from "axios";
import { NPageHeader } from "naive-ui";
import { ref, reactive, computed, onMounted, watch } from "vue";
import { watchOnce } from "@vueuse/core";
import store from "/src/scripts/vuex.ts";

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
