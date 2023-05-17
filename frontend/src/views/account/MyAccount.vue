<template>
  <n-form
    ref="formRef"
    :model="model"
    :rules="rules"
    label-placement="left"
    label-width="auto"
    require-mark-placement="right-hanging"
    size="medium"
    :style="{ maxwidth: '800px', align: ' center ' }"
  >
    <n-form-item label="Email" path="email">
      <n-input v-model:value="model.email" placeholder="請輸入 Email" />
    </n-form-item>
    <n-form-item label="密碼" path="password">
      <n-input v-model:value="model.password" placeholder="請輸入密碼" />
    </n-form-item>
    <n-button attr-type="button" @click="login"> 登入帳號 </n-button>
    <n-button attr-type="button" @click="regist"> 註冊帳號 </n-button>
  </n-form>
</template>

<script setup lang="ts">
import axios from "axios";
import {
  NForm,
  NInput,
  NFormItem,
  NDatePicker,
  NSelect,
  FormRules,
  FormInst,
  NButton,
  NCard,
  FormItemRule,
} from "naive-ui";
import { ref, reactive, computed } from "vue";

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
          return new Error("Email is required");
        } else if (!/@/.test(value)) {
          return new Error("Email format is incorrect");
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
          return new Error("Password is required");
        }
        return true;
      },
      trigger: ["input", "blur"],
    },
  ],
};

function login() {
  //axios post
  axios
    .post("http://localhost:3000/sign_in", {
      account: model.email,
      password: model.password,
    })
    .then(function (response) {
      console.log(response);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}

function regist() {
  //axios post
  axios
    .post("http://localhost:3000/sign_up", {
      account: model.email,
      password: model.password,
    })
    .then(function (response) {
      console.log(response);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
</script>
