<template>
  <n-card class="card">
    <n-space size="large" line-height="20px">
      <n-button @click="tmp" size="large">返回</n-button>
      <n-h3 class="cardtitle">使用者資訊設定</n-h3>
    </n-space>
    <n-space justify="center" class="content2">
      <n-card :bordered="false" size="huge" role="dialog" aria-modal="true">
        <n-form ref="formRef" :label-width="80">
          <n-form-item label="用戶名稱"
            ><n-input v-model:value="model.nickname"></n-input
          ></n-form-item>
          <n-form-item label="密碼"
            ><n-input v-model:value="model.password"></n-input
          ></n-form-item>
          <n-form-item label="設定權限"
            ><n-select
              v-model:value="model.role"
              :options="roleOptions"
            ></n-select
          ></n-form-item>
        </n-form>
        <template #footer>
          <n-space vertical>
            <n-popconfirm @positive-click="handlePositiveClick()"
              ><template #trigger><n-button>刪除</n-button></template
              >確認刪除帳號</n-popconfirm
            >
            <n-button @click="SaveEdit">儲存</n-button>
          </n-space>
        </template>
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
  NForm,
  NFormItem,
  NInput,
  NSelect,
  NPopconfirm,
} from "naive-ui";
import type { DataTableColumns } from "naive-ui";
import { computed, h, onMounted, ref, watch, reactive } from "vue";
import { watchOnce } from "@vueuse/core";
import { User, Role } from "../scripts/types";
import axios from "axios";
import router from "@/router";
import store from "@/scripts/vuex";
const model: User = reactive({
  id: 0,
  account: "",
  password: "",
  nickname: "",
  role: Role.user,
  picture: null,
});
onMounted(() => {
  console.log(store.state.editinfo);
  model.nickname = store.state?.editinfo?.nickname as unknown as string;
  model.id = store.state?.editinfo?.id as unknown as number;
  model.password = store.state?.editinfo?.password as unknown as string;
  model.role = store.state?.editinfo?.role as unknown as string;
});
const roleOptions = computed(() =>
  [Role[0], Role[1]].map((v, index) => ({
    label: Role[index],
    value: Role[index],
  }))
);
function tmp() {
  console.log("hi");
  router.push("/memberlist");
}
function SaveEdit() {
  console.log(model);
  //axios patch
  axios
    .patch(
      "http://localhost:3000/api/admin/authorization/" +
        (model.id as unknown as string),
      {
        nickname: model?.nickname,
        password: model?.password,
        role: model?.role,
      }
    )
    .then(function (response) {
      console.log(response);
      router.push("/memberlist");
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
function handlePositiveClick() {
  deleteAccount();
}
function deleteAccount() {
  console.log(model);
  //axios delete
  axios
    .delete(
      "http://localhost:3000/api/admin/authorization/" +
        (model.id as unknown as string)
    )
    .then(function (response) {
      console.log(response);
      router.push("/memberlist");
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
</script>
