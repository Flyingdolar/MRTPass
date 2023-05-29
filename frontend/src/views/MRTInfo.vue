<template>
  <h1>This is info</h1>
</template>

<script setup lang="ts">
import axios from "axios";
import {
  NForm,
  NInput,
  NFormItem,
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
