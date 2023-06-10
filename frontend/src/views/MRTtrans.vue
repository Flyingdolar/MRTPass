<template>
  <n-space size="large" line-height="20px" vertical>
    <n-card>
      <n-h3 class="cardtitle">trans</n-h3>
      <n-space v-if="roleisAdmin" justify="center">
        <n-button @click="showNewTrans = true">新增轉乘資訊</n-button>
      </n-space>
    </n-card>
  </n-space>
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
import { useRoute } from "vue-router";
const showNewTrans = ref(false);
const route = useRoute();
const roleisAdmin = computed(() => {
  if ((store.state?.userinfo?.role as string) == "admin") {
    return true;
  } else if ((store.state?.userinfo?.role as string) == "mrt_admin") {
    return true;
  }
  return false;
});
watch(store.state, () => {
  getTrans();
});
function getTrans() {
  if (store.state.currentlinestation) {
    //axios get
    axios
      .get("http://localhost:3000/api/mrt_admin/trans", {
        params: {
          station_id: store.state.currentlinestation?.station.id,
        },
      })
      .then(function (response) {
        console.log(response);
      })
      .catch(function (error) {
        console.log(error);
      });
    //axios
  }
}
</script>
