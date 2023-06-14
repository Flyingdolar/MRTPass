<template>
  <div flex="~ col" justify="center items-end" h="10" bg="white">
    <div flex="~" m="t-auto b-10px l-6 r-17" justify="items-center">
      <n-button @click="backto" quaternary>
        <n-icon :size="20"><back /></n-icon>
      </n-button>
      <div
        flex="grow"
        mt="1"
        text="title center bottom"
        style="font-size: 16px"
      >
        使用者一覽
      </div>
    </div>
    <div p="y-1pt" bg=" gray-200" />
  </div>
  <div flex="~ col gap-3" h="160" overflow="auto">
    <div py="1.5" />
    <div v-for="user in colData" :key="user.id" bg="white">
      <div flex="~" m="x-6 y-5" justify="items-center">
        <n-icon size="32" v-if="showImage(user.picture == null)">
          <user :class="userColor(user.role.toString())" />
        </n-icon>
        <n-image :src="showImage(user.picture)" />
        <div flex="grow" m="y-auto l-4" text="body">
          <div>{{ user.nickname }}</div>
          <div>{{ user.role }}</div>
        </div>
        <n-button quaternary @click="editMember(user)">
          <template #icon>
            <n-icon><goto /></n-icon>
          </template>
        </n-button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import {
  NCard,
  NSpace,
  NButton,
  NIcon,
  NModal,
  NDataTable,
  useMessage,
  NH3,
} from "naive-ui";
import back from "../assets/icon/iExpLeft.vue";
import goto from "../assets/icon/iExpRight.vue";
import user from "../assets/icon/iUser.vue";
import type { DataTableColumns } from "naive-ui";
import { computed, h, onMounted, ref, watch } from "vue";
import { watchOnce } from "@vueuse/core";
import { User, Role } from "../scripts/types";
import axios from "axios";
import router from "@/router";
import store from "@/scripts/vuex";
const EditUsermodal = ref(false);
const colData = ref<User[]>([]);
onMounted(() => {
  //axios get
  axios
    .get("http://localhost:3000/api/admin/authorization")
    .then(function (response) {
      // console.log(response.data.data);
      colData.value = response.data.data.map(function (item, index, array) {
        return {
          account: item.account,
          id: item.id,
          nickname: item.nickname,
          password: item.password,
          picture: item.picture,
          role: item.role,
        };
      });
      // console.log(colData.value);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
});
const toEditUser: User = {
  id: 0,
  nickname: "",
  account: "",
  password: "",
  role: Role.user,
  picture: null,
};
const backto = () => {
  router.push("/profile");
};

function userColor(role: string) {
  if (role == "admin") return "text-red";
  else if (role == "mrt_admin") return "text-orange";
  else return "text-blue";
}
function showImage(picture: any) {
  if (picture != null) return "http://localhost:3000" + picture;
  else return null;
}
function editMember(user: User) {
  toEditUser.id = user.id;
  toEditUser.nickname = user.nickname;
  toEditUser.account = user.account;
  toEditUser.password = user.password;
  toEditUser.role = user.role;
  store.dispatch("editinfo", toEditUser);
  router.push("/memberlist/edit");
}
</script>

<style scoped>
::-webkit-scrollbar {
  display: none;
}
</style>
