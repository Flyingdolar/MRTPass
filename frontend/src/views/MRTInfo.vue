<template>
  <!-- Header: 選擇出發站點 -->
  <div p="x-4 y-3" space="y-1" bg="blue-100">
    <div text="title">選擇出發站點</div>
    <div flex="~" space="x-4">
      <n-select :value="depRoute" :options="routeOpt"></n-select>
      <n-select :value="depRoute" :options="routeOpt"></n-select>
    </div>
  </div>
  <!-- Body: -->
</template>

<script setup lang="ts">
import axios from "axios";
import {
  NSelect,
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

let depRoute = ref("");
let routeOpt = reactive([
  // FIXME: 路線資料應該改為後端抓取
  { label: "淡水信義線", value: "R" },
  { label: "板南線", value: "BL" },
  { label: "中和新蘆線", value: "O" },
  { label: "文湖線", value: "BR" },
  { label: "松山新店線", value: "G" },
  { label: "小碧潭支線", value: "LG" },
  { label: "環狀線", value: "Y" },
]);

// Get Route Optiona
</script>
