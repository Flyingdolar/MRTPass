<!-- eslint-disable prettier/prettier -->
<template>
  <n-list>
    <template #header> 個人資料 </template>
    <n-list-item>
      <n-thing title="Thing" title-extra="extra" description="description">
        <n-button>修改使用者名稱</n-button><br />
        <n-button>修改頭像照片</n-button><br />
        <n-button>修改密碼</n-button><br />
      </n-thing>
    </n-list-item>
  </n-list>
  <n-list v-if="roleisAdmin">
    <template #header> 管理 </template>
    <n-list-item>
      <n-thing title="Thing" title-extra="extra" description="description">
        <n-button>使用者權限</n-button><br />
        <n-button>捷運資訊調整</n-button><br />
      </n-thing>
    </n-list-item>
  </n-list>
  <n-button @click="logout">登出</n-button>
</template>

<script setup lang="ts">
import router from "@/router";
import axios from "axios";
import { NList, NListItem, NButton } from "naive-ui";
import { ref, reactive, computed, onMounted } from "vue";
import store from "/src/scripts/vuex.ts";
const roleisAdmin = ref(false);
onMounted(() => {
  store.dispatch("role", "admin");
  console.log(store.state.role);
  if (store.state.role == "admin") {
    roleisAdmin.value = true;
  }
});
function logout() {
  //axios post
  axios
    .post("http://localhost:3000/sign_out")
    .then(function (response) {
      console.log(response);
      store.dispatch("isLogin", false);
      store.dispatch("user", "");
      store.dispatch("role", "");
      store.dispatch("username", "");
      router.push("/account");
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
</script>
