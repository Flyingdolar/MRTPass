<template>
  <!-- Empty View -->
  <div v-if="CurrentCommon?.length == 0">
    <div m="x-auto y-6" text="center secondary">查無周遭景點資訊</div>
  </div>
  <!-- List -->
  <div space="y-3" m="t-3 b-20">
    <n-card
      v-for="item in CurrentCommon"
      :key="item?.info.id"
      footer-style="padding: 0;"
      :bordered="false"
    >
      <template #header>
        <div justify="items-end" flex="~" w="full">
          <div flex="grow" text="lg title">
            {{ item.info.name }}
          </div>
        </div>
      </template>
      <template #header-extra>
        <n-button @click="viewCommon(item.info.id)" type="primary" quaternary>
          <template #icon>
            <n-icon :size="18"><star /></n-icon>
          </template>
          <div>查看景點</div>
        </n-button>
      </template>
      <!-- Common Image -->
      <div v-if="getImage(item.info.photo) != null" flex="~" justify="center">
        <img w="full" m="b-4" :src="getImage(item.info.photo)" />
      </div>
      <div style="white-space: pre-line">
        {{ item.info.Des }}
      </div>
      <template #footer>
        <div flex="~" justify="center items-center" p="x-4 y-2" v-if="isLogin">
          <n-button
            @click="showOldCommon(item.info.id)"
            flex="~ grow"
            size="medium"
            type="info"
            quaternary
          >
            <template #icon>
              <n-icon :size="18"><edit /></n-icon>
            </template>
            <div>編輯</div>
          </n-button>
          <div m="1" p="0.8px" bg="gray-200" v-if="roleisAdmin" />
          <n-button
            @click="showConfirmDelete(item.info.id)"
            flex="~ grow"
            size="medium"
            type="error"
            quaternary
            v-if="roleisAdmin"
          >
            <template #icon>
              <n-icon :size="18"><trash /></n-icon>
            </template>
            <div>刪除</div>
          </n-button>
        </div>
      </template>
    </n-card>
  </div>

  <!-- Card: New Annoucement -->
  <n-card
    v-if="isLogin"
    pos="fixed bottom-16"
    footer-style="padding: 0px;"
    :hoverable="true"
  >
    <template #footer>
      <div class="flex justify-center py-4 px-12">
        <n-button
          flex="~ grow"
          type="success"
          ghost
          @click="showNewCommon = true"
        >
          <template #icon>
            <n-icon :size="18"><add /></n-icon>
          </template>
          新增景點
        </n-button>
      </div>
    </template>
  </n-card>

  <!-- Overlay: Edit Annoucement -->
  <n-modal v-model:show="OldCommonshow">
    <n-card title="編輯景點資訊" :header-style="{ 'align-self': 'center' }">
      <n-form
        ref="formRef"
        :label-width="80"
        :model="model"
        :rules="rules"
        require-mark-placement="right-hanging"
      >
        <n-form-item label="景點名字" path="topic">
          <n-input v-model:value="model.newtopic" placeholder="輸入景點名字" />
        </n-form-item>
        <n-form-item label="地址" path="topic">
          <n-input v-model:value="model.newaddress" placeholder="輸入地址" />
        </n-form-item>
        <n-form-item label="景點描述" path="context">
          <template #header-extra> 必填 </template>
          <n-input
            v-model:value="model.newcontent"
            type="textarea"
            placeholder="輸入內文"
          />
        </n-form-item>
        <n-form-item label="圖片" path="title">
          <n-upload
            :on-before-upload="handleImgBefore"
            :on-update-file-list="handleImgChange"
          >
            <n-upload-dragger w="full">
              <div
                p="x-4 y-4"
                bg="hover:blue-100"
                text="seconary hover:blue"
                border="rounded-lg 1 gray-200 hover:blue-400"
              >
                <div flex="~" justify="center">
                  <n-icon size="48"><add /></n-icon>
                </div>
              </div>
            </n-upload-dragger>
          </n-upload>
        </n-form-item>
      </n-form>
      <template #footer>
        <div flex="~ gap-8" class="justify-center px-12">
          <n-button @click="SubmitEditCommon" type="primary" flex="grow" ghost>
            <template #icon>
              <n-icon :size="18"><save /></n-icon>
            </template>
            <div>儲存</div>
          </n-button>
          <n-button
            @click="OldCommonshow = false"
            type="tertiary"
            flex="grow"
            ghost
          >
            <template #icon>
              <n-icon :size="18"><back /></n-icon>
            </template>
            <div>取消</div>
          </n-button>
        </div>
      </template>
    </n-card>
  </n-modal>
  <!-- Overlay: Confirm Delete -->
  <n-modal v-model:show="ConfirmDeleteshow">
    <n-card
      w="3/4 min-30"
      title="確定要刪除？"
      :header-style="{ 'align-self': 'center' }"
    >
      <div text="sm center secondary" pb="2">請注意，刪除後無法復原</div>
      <template #footer>
        <div flex="~ gap-8" class="justify-center px-2">
          <n-button @click="deleteCommon" type="error" flex="grow" ghost>
            <template #icon>
              <n-icon :size="18"><trash /></n-icon>
            </template>
            <div>刪除</div>
          </n-button>
          <n-button
            @click="ConfirmDeleteshow = false"
            type="tertiary"
            flex="grow"
            ghost
          >
            <template #icon>
              <n-icon :size="18"><back /></n-icon>
            </template>
            <div>取消</div>
          </n-button>
        </div>
      </template>
    </n-card>
  </n-modal>
  <!-- Overlay: New Annoucement -->
  <n-modal v-model:show="showNewCommon">
    <n-card title="建立景點" :header-style="{ 'align-self': 'center' }">
      <n-form
        ref="formRef"
        :label-width="100"
        :model="model"
        :rules="rules"
        require-mark-placement="right-hanging"
      >
        <n-form-item label="景點名稱" path="topic">
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
              v-model:value="Current.dynamicInputValue[index].CurrentStation"
              :options="stationOpt[index]"
              placeholder="請選擇站點"
            />
          </n-dynamic-input>
        </n-form-item>

        <n-form-item label="地址" path="address">
          <template #header-extra> 必填 </template>
          <n-input v-model:value="model.address" placeholder="輸入內文" />
        </n-form-item>
        <n-form-item label="景點描述" path="context">
          <template #header-extra> 必填 </template>
          <n-input
            v-model:value="model.context"
            type="textarea"
            placeholder="輸入內文"
          />
        </n-form-item>
        <n-form-item label="圖片" path="title">
          <n-upload
            :on-before-upload="handleImgBefore"
            :on-update-file-list="handleImgChange"
          >
            <n-upload-dragger w="full">
              <div
                p="x-4 y-4"
                bg="hover:blue-100"
                text="seconary hover:blue"
                border="rounded-lg 1 gray-200 hover:blue-400"
              >
                <div flex="~" justify="center">
                  <n-icon size="48"><add /></n-icon>
                </div>
              </div>
            </n-upload-dragger>
          </n-upload>
        </n-form-item>
      </n-form>
      <template #footer>
        <div flex="~ gap-8" class="justify-center px-12">
          <n-button @click="NewCommonSubmitt" type="primary" flex="grow" ghost>
            <template #icon>
              <n-icon :size="18"><save /></n-icon>
            </template>
            <div>儲存</div>
          </n-button>
          <n-button
            @click="showNewCommon = false"
            type="tertiary"
            flex="grow"
            ghost
          >
            <template #icon>
              <n-icon :size="18"><back /></n-icon>
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
  NUpload,
  NImage,
} from "naive-ui";
import star from "../assets/icon/iStar.vue";
import trash from "../assets/icon/iTrash.vue";
import add from "../assets/icon/iAdd.vue";
import edit from "../assets/icon/iEdit.vue";
import type { DataTableColumns } from "naive-ui";
import { computed, h, onBeforeMount, ref, watch, reactive } from "vue";
import { watchOnce } from "@vueuse/core";
import { User, Role } from "../scripts/types";
import axios from "axios";
import router from "@/router";
import store from "@/scripts/vuex";
import { useRoute } from "vue-router";
import {
  Station,
  Line,
  LineStation,
  AlotsLineStation,
  Common,
} from "../scripts/types";
import back from "../assets/icon/iRefund.vue";
import save from "../assets/icon/iSave.vue";
const isLogin = computed(() => (store?.state?.userinfo ? true : false));
const route = useRoute();
const message = useMessage();
const Current = ref({
  dynamicInputValue: [
    {
      CurrentRoute: "",
      CurrentStation: null,
    },
  ],
});
const showNewCommon = ref(false);
const roleisAdmin = computed(() => {
  if ((store.state?.userinfo?.role as string) == "admin") {
    return true;
  } else if ((store.state?.userinfo?.role as string) == "mrt_admin") {
    return false;
  }
  return false;
});
const model = reactive({
  name: "",
  context: "",
  address: "",
  newtopic: "",
  newaddress: "",
  newcontent: "",
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
  address: [
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
};
watch(store.state, () => {
  getCommon();
});
const CurrentCommon = ref<Common[]>([]);
function getImage(photo: any) {
  if (photo == null) return null;
  if (photo.url == null) return null;
  return "http://localhost:3000" + photo.url;
}
function getCommon() {
  if (store.state.currentlinestation) {
    //axios get
    axios
      .get("http://localhost:3000/api/mrt_admin/common", {
        params: {
          station_id: store.state.currentlinestation?.station.id,
        },
      })
      .then(function (response) {
        // console.log(response);
        CurrentCommon.value = response.data.data;
        // console.log(CurrentCommon.value);
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
  getCommon();
});
function NewCommonSubmitt() {
  const goodformcheck = ref(true);
  Current.value.dynamicInputValue.forEach(function (item, index, array) {
    if (!item.CurrentStation) {
      goodformcheck.value = false;
    }
  });
  const itemaddress = ref("");
  CurrentLineStation.value[0].item.forEach(function (item, index, array) {
    if (item.station.id == Current.value.dynamicInputValue[0].CurrentStation) {
      itemaddress.value = item.station.name;
    }
  });
  const stationid1 = computed(() => {
    if (Current.value.dynamicInputValue[0]) {
      return Current.value.dynamicInputValue[0].CurrentStation;
    } else {
      return null;
    }
  });
  const stationid2 = computed(() => {
    if (Current.value.dynamicInputValue[1]) {
      return Current.value.dynamicInputValue[1].CurrentStation;
    } else {
      return null;
    }
  });
  const stationid3 = computed(() => {
    if (Current.value.dynamicInputValue[2]) {
      return Current.value.dynamicInputValue[2].CurrentStation;
    } else {
      return null;
    }
  });

  if (goodformcheck.value) {
    formData.append("name", model.name);
    formData.append("address", model.address);
    formData.append("Des", model.context);
    formData.append("station_id_1", stationid1.value);
    formData.append("station_id_2", stationid2.value);
    formData.append("station_id_3", stationid3.value);
    //axios post
    axios
      .post("http://localhost:3000/api/mrt_admin/common", formData)
      .then(function (response) {
        // console.log(response.data.data);
        message.success("新增成功");
        getCommon();
        showNewCommon.value = false;
      })
      .catch(function (error) {
        console.log(error);
      });
    //axios
  } else {
    message.error("請填滿空欄或刪除多餘的");
  }
}
const formData = new FormData();
function handleImgBefore(event: any) {
  const file = event.file;
  const isImage = file.type.includes("image");
  const fileSize = file.file.size / 1024 / 1024;
  // TODO: 顯示錯誤訊息
  if (!isImage) console.error("上傳內容必須為圖片格式!");
  if (fileSize > 2) console.error("上傳圖片大小不能超過2MB!");
  return isImage && fileSize < 2;
}

function handleImgChange(event: any) {
  formData.delete("photo");
  if (event.length === 0) return;
  formData.append("photo", event[0].file, event[0].file.name);
}

function handleImgRemove() {
  formData.delete("picture");
}

function cancelChange() {
  formData.delete("picture");
}
const CommonID = ref(-1);
const ConfirmDeleteshow = ref(false);
const OldCommonshow = ref(false);
const OldCommonindex = ref(-1);
function showConfirmDelete(id: number) {
  ConfirmDeleteshow.value = true;
  CommonID.value = id;
  //console.log(AnnouncementID);
}
function showImage(item) {
  if (item.photo.url != null) return "http://localhost:3000" + item.photo.url;
}
function deleteCommon() {
  //axios delete
  axios
    .delete("http://localhost:3000/api/mrt_admin/info/" + CommonID.value)
    .then(function (response) {
      console.log(response.data.data);
      ConfirmDeleteshow.value = false;
      getCommon();
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
function showOldCommon(id: number) {
  OldCommonshow.value = true;
  CommonID.value = id;
  //console.log(AnnouncementID);
  CurrentCommon.value.forEach((item, index) => {
    if (item.info.id == CommonID.value) {
      OldCommonindex.value = index;
    }
  });
  model.newtopic = CurrentCommon.value[OldCommonindex.value].info.name;
  model.newaddress = CurrentCommon.value[OldCommonindex.value].info.address;
  model.newcontent = CurrentCommon.value[OldCommonindex.value].info.Des;
  //console.log(OldAnnounceindex.value);
}
function SubmitEditCommon() {
  formData.append("name", model.newtopic);
  formData.append("address", model.newaddress);
  formData.append("Des", model.newcontent);
  //axios patch
  axios
    .patch(
      "http://localhost:3000/api/mrt_admin/common/" + CommonID.value,
      formData
    )
    .then(function (response) {
      // console.log(response.data.data);
      message.success("修改成功");
      getCommon();
      OldCommonshow.value = false;
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
function viewCommon(id: number) {
  console.log(id);
  router.push("/Common/" + id.toString());
}
</script>

<style scoped>
::-webkit-scrollbar {
  display: none;
}
</style>
