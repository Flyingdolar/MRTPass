<template>
  <n-space size="large" line-height="20px" vertical>
    <n-card>
      <n-h3 class="cardtitle">trans</n-h3>
      <n-space v-if="roleisAdmin" justify="center">
        <n-button @click="showNewTrans = true">新增轉乘資訊</n-button>
      </n-space>
      <n-modal v-model:show="showNewTrans">
        <n-card title="建立轉乘資訊" :header-style="{ 'align-self': 'center' }">
          <n-form
            ref="formRef"
            :label-width="100"
            :model="model"
            :rules="rules"
            require-mark-placement="right-hanging"
          >
            <n-form-item label="名稱" path="topic">
              <n-input v-model:value="model.name" placeholder="輸入名稱" />
            </n-form-item>
            <n-form-item label="附近捷運站">
              <n-dynamic-input
                v-model:value="Current.dynamicInputValue"
                placeholder="请输入"
                :on-create="onCreate"
                :min="1"
                :max="3"
                #="{ index, value }"
              >
                <n-select
                  v-model:value="Current.dynamicInputValue[index].CurrentRoute"
                  :options="routeOpt"
                  @update:value="handleUpdateValue(index)"
                  placeholder="請選擇路線"
                />

                <n-select
                  v-model:value="
                    Current.dynamicInputValue[index].CurrentStation
                  "
                  :options="stationOpt[index]"
                  placeholder="請選擇站點"
                />
              </n-dynamic-input>
            </n-form-item>

            <n-form-item label="描述" path="context">
              <template #header-extra> 必填 </template>
              <n-input
                v-model:value="model.context"
                type="textarea"
                placeholder="輸入內文"
              />
            </n-form-item>
          </n-form>
          <template #footer>
            <div flex="~ gap-8" class="justify-center px-12">
              <n-button
                @click="NewTransSubmitt"
                type="primary"
                flex="grow"
                ghost
              >
                <template #icon>
                  <n-icon :size="18"><save /></n-icon>
                </template>
                <div>儲存</div>
              </n-button>
              <n-button
                @click="showNewTrans = false"
                type="tertiary"
                flex="grow"
                ghost
              >
                <template #icon>
                  <n-icon :size="18"><back /></n-icon>
                </template>
                <div>取消</div>
              </n-button>
              <!---
                <n-button @click="print" />
              -->
            </div>
          </template>
        </n-card>
      </n-modal>
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
  NIcon,
  FormRules,
  FormItemRule,
  NDynamicInput,
  messageDark,
} from "naive-ui";
import type { DataTableColumns } from "naive-ui";
import { computed, h, onBeforeMount, ref, watch, reactive } from "vue";
import { watchOnce } from "@vueuse/core";
import axios from "axios";
import router from "@/router";
import store from "@/scripts/vuex";
import { useRoute } from "vue-router";
import { Station, Line, LineStation, AlotsLineStation } from "../scripts/types";
import back from "../assets/icon/iRefund.vue";
import add from "../assets/icon/iAdd.vue";
import edit from "../assets/icon/iEdit.vue";
import save from "../assets/icon/iSave.vue";
const message = useMessage();
const Current = ref({
  dynamicInputValue: [
    {
      CurrentRoute: "",
      CurrentStation: null,
    },
  ],
});
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
const model = reactive({
  name: "",
  context: "",
});
const rules: FormRules = {
  topic: [
    {
      required: true,
      validator(rule: FormItemRule, value: string) {
        if (!value) {
          return new Error("Topic is required");
        }
        return true;
      },
      trigger: ["input", "blur"],
    },
  ],
  context: [
    {
      required: true,
      validator(rule: FormItemRule, value: Text) {
        if (!value) {
          return new Error("Content is required");
        }
        return true;
      },
      trigger: ["input", "blur"],
    },
  ],
  path: {
    required: true,
    validator(rule: FormItemRule, value: Text) {
      if (!value) {
        return new Error("Station is required");
      }
      return true;
    },
    trigger: ["input", "blur"],
  },
};
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
const AllLine = ref<Line[]>();
let CurrentLineStation = ref<AlotsLineStation[]>();

const routeOpt = computed(() =>
  AllLine.value?.map((v, index) => ({
    label: v.name,
    value: v.linecolor,
  }))
);

const stationOpt = computed(() =>
  CurrentLineStation.value?.map((v, index) =>
    v.item.map((s: LineStation, index2) => ({
      label: s.station.name,
      value: s.station.id,
    }))
  )
);
function onCreate() {
  return {
    CurrentRoute: "",
    CurrentStation: null,
  };
}
function print() {
  console.log(Current.value.dynamicInputValue);
}
function handleUpdateValue(index: number) {
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/line_station", {
      params: {
        linecolor: Current.value.dynamicInputValue[index].CurrentRoute,
      },
    })
    .then(function (response) {
      //console.log(response);
      CurrentLineStation.value[index].item = response.data.data;
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}

onBeforeMount(() => {
  //console.log(CurrentStation.value);
  CurrentLineStation = ref<AlotsLineStation[]>([
    {
      item: [
        {
          linecolor: "",
          number: 0,
          station: {
            created_at: "",
            exit_Num: 0,
            id: 0,
            name: "",
            updated_at: "",
            x_Pos: 0,
            y_Pos: 0,
          },
        },
      ],
    },
    {
      item: [
        {
          linecolor: "",
          number: 0,
          station: {
            created_at: "",
            exit_Num: 0,
            id: 0,
            name: "",
            updated_at: "",
            x_Pos: 0,
            y_Pos: 0,
          },
        },
      ],
    },
    {
      item: [
        {
          linecolor: "",
          number: 0,
          station: {
            created_at: "",
            exit_Num: 0,
            id: 0,
            name: "",
            updated_at: "",
            x_Pos: 0,
            y_Pos: 0,
          },
        },
      ],
    },
  ]);
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/line")
    .then(function (response) {
      //console.log(response.data.data);
      AllLine.value = response.data.data;
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
});
function NewTransSubmitt() {
  const goodformcheck = ref(true);
  Current.value.dynamicInputValue.forEach(function (item, index, array) {
    if (!item.CurrentStation) {
      goodformcheck.value = false;
    }
  });
  if (goodformcheck.value) {
    //axios post
    axios
      .post("http://localhost:3000/api/mrt_admin/trans", {
        name: model.name,
        Des: model.context,
      })
      .then(function (response) {
        console.log(response.data.data);
      })
      .catch(function (error) {
        console.log(error);
      });
    //axios
  } else {
    message.error("請填滿空欄或刪除多餘的");
  }
}
</script>
