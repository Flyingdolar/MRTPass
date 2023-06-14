<template>
  <!-- Header -->
  <div flex="~ col" justify="center items-end" h="10" bg="white">
    <div flex="~" m="t-auto b-10px l-6 r-17" justify="items-center">
      <n-button @click="tmp" quaternary>
        <n-icon :size="20"><back /></n-icon>
      </n-button>
      <div
        flex="grow"
        mt="1"
        text="title center bottom"
        style="font-size: 16px"
      >
        編輯使用者
      </div>
    </div>
    <div p="y-1pt" bg=" gray-200" />
  </div>
  <!-- Body -->
  <div flex="~ col gap-3" h="160" overflow="auto">
    <!-- User Account -->
    <div flex="~ gap-4" p="6" bg="white" border="y-2 gray-200">
      <div>用戶帳號：</div>
      <div>{{ model.account }}</div>
    </div>
    <!-- User Form -->
    <n-form ref="formRef" :label-width="80" p="6" bg="white">
      <n-form-item label="用戶名稱"
        ><n-input v-model:value="model.nickname"></n-input
      ></n-form-item>
      <n-form-item label="密碼"
        ><n-input v-model:value="model.password"></n-input
      ></n-form-item>
      <n-form-item label="設定權限"
        ><n-select v-model:value="model.role" :options="roleOptions"></n-select
      ></n-form-item>
    </n-form>
    <div flex="~ gap-8" class="justify-center px-12 py-4 bg-white">
      <n-button @click="SaveEdit" type="primary" flex="grow" ghost>
        <template #icon>
          <n-icon><save /></n-icon>
        </template>
        <div>儲存</div>
      </n-button>
      <n-button @click="showDelete = true" type="error" flex="grow" ghost>
        <template #icon>
          <n-icon><remove /></n-icon>
        </template>
        <div>刪除</div>
      </n-button>
    </div>
  </div>
  <!-- Overlay: Confirm Delete -->
  <n-modal v-model:show="showDelete">
    <n-card
      w="3/4 min-30"
      title="確定要刪除？"
      :header-style="{ 'align-self': 'center' }"
    >
      <div text="sm center secondary" pb="2">請注意，刪除後無法復原</div>
      <template #footer>
        <div flex="~ gap-8" class="justify-center px-2">
          <n-button type="error" flex="grow" ghost @click="deleteAccount">
            <template #icon>
              <n-icon :size="18"><remove /></n-icon>
            </template>
            <div>刪除</div>
          </n-button>
          <n-button
            @click="showDelete = false"
            type="tertiary"
            flex="grow"
            ghost
          >
            <template #icon>
              <n-icon :size="18"><cancel /></n-icon>
            </template>
            <div>取消</div>
          </n-button>
        </div>
      </template>
    </n-card>
  </n-modal>
</template>

<script setup lang="ts">
import {
  NCard,
  NIcon,
  NButton,
  NModal,
  useMessage,
  NForm,
  NFormItem,
  NInput,
  NSelect,
  messageDark,
} from "naive-ui";
import back from "../assets/icon/iExpLeft.vue";
import cancel from "../assets/icon/iRefund.vue";
import save from "../assets/icon/iSave.vue";
import remove from "../assets/icon/iTrash.vue";
import type { DataTableColumns } from "naive-ui";
import { computed, h, onMounted, ref, watch, reactive } from "vue";
import { watchOnce } from "@vueuse/core";
import { User, Role } from "../scripts/types";
import axios from "axios";
import router from "@/router";
import store from "@/scripts/vuex";

const message = useMessage();
const showDelete = ref(false);
const model: User = reactive({
  id: 0,
  account: "",
  password: "",
  nickname: "",
  role: Role.user,
  picture: null,
});
onMounted(() => {
  // console.log(store.state.editinfo);
  model.account = store.state?.editinfo?.account as unknown as string;
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
      message.success("修改成功");
      router.push("/memberlist");
    })
    .catch(function (error) {
      message.error("修改失敗");
      console.log(error);
    });
  //axios
}

function deleteAccount() {
  //axios delete
  axios
    .delete(
      "http://localhost:3000/api/admin/authorization/" +
        (model.id as unknown as string)
    )
    .then(function (response) {
      message.success("刪除成功");
      router.push("/memberlist");
    })
    .catch(function (error) {
      message.error("刪除失敗");
      console.log(error);
    });
  //axios
}
</script>
