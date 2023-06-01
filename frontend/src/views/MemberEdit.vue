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
            <n-button>刪除帳號</n-button>
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
} from "naive-ui";
import type { DataTableColumns } from "naive-ui";
import { computed, h, onMounted, ref, watch, reactive } from "vue";
import { watchOnce } from "@vueuse/core";
import { User, Role } from "../scripts/types";
import axios from "axios";
import router from "@/router";
import store from "@/scripts/vuex";
const model = reactive({
  id: "",
  nickname: "",
  photo: "",
  password: "",
  role: "",
  account: "",
});
onMounted(() => {
  console.log(store.state.editinfo);
  model.nickname = store.state?.editinfo?.nickname;
  model.password = store.state?.editinfo?.password;
  model.role = store.state?.editinfo?.role;
});
const roleOptions = computed(() =>
  [Role[0], Role[1], Role[2]].map((v, index) => ({
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
}
</script>
