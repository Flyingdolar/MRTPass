<template>
  <n-form
    ref="formRef"
    :model="model"
    :rules="rules"
    label-width="auto"
    require-mark-placement="right-hanging"
    size="medium"
    :style="{ maxwidth: '800px', align: ' center ' }"
    class="flex flex-col my-3 gap-3"
  >
    <!-- Login State -->
    <div bg="white" border="gray-200 1">
      <div flex="~ gap-6" justify="items-center" p="x-6 y-4">
        <n-icon size="48"><userIcon /></n-icon>
        <div flex="~ col gap-2">
          <div text="base title">尚未登入</div>
          <div text="xs secondary">訪客使用者</div>
        </div>
      </div>
    </div>
    <!-- Input forms -->
    <div flex="~ col gap-4" p="x-6 y-4" bg="white">
      <n-form-item label="帳號" path="email">
        <n-input v-model:value="model.email" placeholder="請輸入帳號" />
      </n-form-item>
      <n-form-item label="密碼" path="password">
        <n-input
          v-model:value="model.password"
          type="password"
          show-password-on="click"
          placeholder="請輸入密碼"
        />
      </n-form-item>
    </div>
    <div flex="~ gap-8" justify="center" p="x-12 y-4" bg="white">
      <n-button @click="login" type="primary" flex="grow" ghost>
        <template #icon>
          <n-icon :size="18"><signin /></n-icon>
        </template>
        <div>登入帳號</div>
      </n-button>
      <n-button @click="regist" type="default" flex="grow" ghost>
        <template #icon>
          <n-icon :size="18"><userAdd /></n-icon>
        </template>
        <div>註冊帳號</div>
      </n-button>
    </div>
    <!-- <n-button @click="logoutbutton">我再出現一次我就是小丑</n-button>- -->
  </n-form>
  <div flex="~" text="xs secondary" justify="center">
    <div>登入、註冊之後，便可以張貼景點資訊與在景點留下評論喔！</div>
  </div>
</template>

<script setup lang="ts">
import router from "@/router";
import axios from "axios";
import {
  NForm,
  NIcon,
  NInput,
  NFormItem,
  FormRules,
  useMessage,
  NButton,
  FormItemRule,
} from "naive-ui";
import signin from "../../assets/icon/iSignin.vue";
import userIcon from "../../assets/icon/iUser.vue";
import userAdd from "../../assets/icon/iUserAdd.vue";
import { ref, reactive, computed, onMounted, watch } from "vue";
import { watchOnce } from "@vueuse/core";
import store from "/src/scripts/vuex.ts";
const isLogin = computed(() => (store?.state?.userinfo ? true : false));
const message = useMessage();

onMounted(() => {
  if (!isLogin.value) {
    fetchsession();
    watchOnce(isLogin, () => {
      router.push("/profile");
    });
  }
  //console.log(store.state.userinfo);
  else {
    router.push("/profile");
  }
});
const model = reactive({
  email: "",
  password: "",
});

const rules: FormRules = {
  email: [
    {
      required: true,
      validator(rule: FormItemRule, value: string) {
        if (!value) {
          return new Error("需要輸入帳號");
        }
        return true;
      },
      trigger: ["input", "blur"],
    },
  ],
  password: [
    {
      required: true,
      validator(rule: FormItemRule, value: string) {
        if (!value) {
          return new Error("需要輸入密碼");
        }
        return true;
      },
      trigger: ["input", "blur"],
    },
  ],
};
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
function login() {
  //axios post
  axios
    .post("http://localhost:3000/sign_in", {
      account: model.email,
      password: model.password,
    })
    .then(function (response) {
      message.success("登入成功");
      store.dispatch("userinfo", response.data.data);
    })
    .catch(function (error) {
      message.error("登入失敗，請確認帳號密碼是否正確");
    });
  //axios
  watchOnce(isLogin, () => {
    router.push("/profile");
  });
}

function regist() {
  //axios post
  axios
    .post("http://localhost:3000/sign_up", {
      account: model.email,
      password: model.password,
    })
    .then(function (response) {
      message.success("註冊成功");
    })
    .catch(function (error) {
      message.error("註冊失敗，請確認帳號是否已被註冊或是否設定密碼");
    });
  //axios
}
/*
function logoutbutton() {
  //axios post
  axios
    .post("http://localhost:3000/sign_out")
    .then(function (response) {
      //console.log(response);
      store.dispatch("userinfo", undefined);
      router.push("/account");
    })
    .catch(function (error) {
      store.dispatch("userinfo", undefined);
      console.log(error);
      router.push("/account");
    });
  //axios
}*/
</script>
