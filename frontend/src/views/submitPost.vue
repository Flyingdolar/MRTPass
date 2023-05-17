<template>
  <n-form
    ref="formRef"
    :model="model"
    label-placement="left"
    label-width="auto"
    require-mark-placement="right-hanging"
    size="medium"
    :style="{ maxwidth: '800px', align: ' center ' }"
  >
    <n-form-item label="標題" path="user.name">
      <n-input v-model:value="model.topic" placeholder="輸入標題" />
    </n-form-item>
    <n-form-item label="內文" path="user.age">
      <n-input
        v-model:value="model.context"
        type="textarea"
        placeholder="輸入內文"
      />
    </n-form-item>
    <n-button attr-type="button" @click="submitpost"> 送出 </n-button>
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
  topic: "",
  context: "",
});

function submitpost() {
  //axios post
  axios
    .post("http://localhost:3000/api/mrt_admin/announcement", {
      topic: model.topic,
      context: model.context,
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
