<template>
  <n-card class="card">
    <n-space justify="space-around" size="large" line-height="20px">
      <n-button @click="tmp" size="large">返回</n-button>
      <n-h3 class="cardtitle">捷運路線</n-h3>
      <n-button @click="tmp" size="large">搜尋</n-button>
    </n-space>
    <n-space justify="center" class="content2">
      <n-card
        :header-style="{ 'align-self': 'center' }"
        :footer-style="{ 'align-self': 'center' }"
      >
        <n-data-table :columns="columns" :data="colData" :max-height="250" />
      </n-card>
    </n-space>
  </n-card>
</template>

<script setup lang="ts">
import {
  NCard,
  NSpace,
  NButton,
  NModal,
  NDataTable,
  useMessage,
  NH3,
} from "naive-ui";
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
    .get("http://localhost:3000/api/mrt_admin/line")
    .then(function (response) {
      console.log(response);
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
      console.log(colData.value);
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
const createColumns = ({
  edit,
}: {
  edit: (row: User) => void;
}): DataTableColumns<User> => {
  return [
    {
      title: "nickname",
      key: "nickname",
    },
    {
      title: "edit",
      key: "actions",
      render(row) {
        return h(
          NButton,
          {
            strong: true,
            tertiary: true,
            size: "small",
            onClick: () => edit(row),
          },
          { default: () => "edit" }
        );
      },
    },
  ];
};
let columns = createColumns({
  edit(row: User) {
    toEditUser.id = row.id;
    toEditUser.nickname = row.nickname;
    toEditUser.account = row.account;
    toEditUser.password = row.password;
    toEditUser.role = row.role;
    store.dispatch("editinfo", toEditUser);
    router.push("/memberlist/edit");
  },
});
function tmp() {
  console.log("hi");
  router.push("/profile");
}
</script>
