<template>
  <div flex="~ col" justify="center items-end" h="10" bg="white">
    <div flex="~" m="t-auto b-10px x-6" justify="items-center">
      <n-button @click="goback" quaternary>
        <n-icon :size="20"><back /></n-icon>
      </n-button>
      <div
        flex="grow"
        mt="1"
        text="title center bottom"
        style="font-size: 16px"
      >
        捷運路線
      </div>
      <n-button @click="tmp" quaternary>
        <n-icon :size="20"><search /></n-icon>
      </n-button>
    </div>
    <div p="y-1pt" bg=" gray-200" />
  </div>
  <div flex="~ col gap-3" h="160" overflow="auto">
    <div py="3px" />
    <div v-for="line in colData" :key="line.id" bg="white">
      <div flex="~" m="x-6 y-5" justify="items-center">
        <div
          flex="~ grow gap-4"
          m="y-auto l-4"
          text="body"
          justify="items-center"
        >
          <div
            w="8"
            border="2 rounded-lg opacity-20"
            :style="setLineColor(line.colorcode)"
          >
            <div text="center">{{ line.linecolor }}</div>
          </div>
          <div>{{ line.name }}</div>
        </div>
        <div flex="~ gap-6">
          <n-button ghost @click="openDelete(line.id)">
            <template #icon>
              <n-icon text="danger"><remove /></n-icon>
            </template>
          </n-button>
          <n-button quaternary @click="EditLine(line.id)">
            <template #icon>
              <n-icon><goto /></n-icon>
            </template>
          </n-button>
        </div>
      </div>
    </div>
    <div py="3px" />
  </div>
  <div p="9" />

  <!-- Card: New Annoucement -->
  <n-card pos="fixed bottom-16" footer-style="padding: 0px;" :hoverable="true">
    <template #footer>
      <div class="flex justify-center py-4 px-16">
        <n-button
          flex="~ grow"
          type="success"
          ghost
          @click="showNewLine = true"
        >
          <template #icon>
            <n-icon :size="18"><add /></n-icon>
          </template>
          新增路線
        </n-button>
      </div>
    </template>
  </n-card>

  <!-- Overlay: New Annoucement -->
  <n-modal v-model:show="showNewLine">
    <n-card title="新增路線" :header-style="{ 'align-self': 'center' }">
      <n-form ref="formRef" :label-width="80">
        <n-form-item label="路線代號"
          ><n-input v-model:value="model.linecolor"></n-input
        ></n-form-item>
        <n-form-item label="路線名稱"
          ><n-input v-model:value="model.name"></n-input
        ></n-form-item>
        <n-form-item label="路線顏色"
          ><n-input v-model:value="model.colorcode"></n-input
        ></n-form-item>
      </n-form>
      <template #footer>
        <div flex="~ gap-8" class="justify-center px-12">
          <n-button @click="addNewLine" type="primary" flex="grow" ghost>
            <template #icon>
              <n-icon :size="18"><save /></n-icon>
            </template>
            <div>儲存</div>
          </n-button>
          <n-button
            @click="showNewLine = false"
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
          <n-button type="error" flex="grow" ghost @click="DeleteLine">
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
  NForm,
  NInput,
  NFormItem,
  NButton,
  NModal,
  useMessage,
} from "naive-ui";
import back from "../assets/icon/iExpLeft.vue";
import goto from "../assets/icon/iExpRight.vue";
import remove from "../assets/icon/iTrash.vue";
import search from "../assets/icon/iSearch.vue";
import cancel from "../assets/icon/iRefund.vue";
import save from "../assets/icon/iSave.vue";
import type { DataTableColumns } from "naive-ui";
import { computed, h, onMounted, ref, reactive, watch } from "vue";
import { watchOnce } from "@vueuse/core";
import { Line, Role } from "../scripts/types";
import axios from "axios";
import router from "@/router";
import store from "@/scripts/vuex";
const EditUsermodal = ref(false);
const colData = ref<Line[]>([]);
const showNewLine = ref(false);
const showDelete = ref(false);
const selectID = ref(0);
const message = useMessage();
const model = reactive({
  id: 0,
  name: "",
  linecolor: "",
  colorcode: "",
});

function reloadLine() {
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/line")
    .then(function (response) {
      console.log(response);
      colData.value = response.data.data.map(function (item, index, array) {
        return {
          id: item.id,
          name: item.name,
          linecolor: item.linecolor,
          colorcode: item.colorcode,
        };
      });
      //console.log(colData.value);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
onMounted(() => {
  reloadLine();
});

function setLineColor(color: string) {
  return "color: " + color + "; border-color: " + color + ";";
}

function addNewLine() {
  //axios post
  axios
    .post("http://localhost:3000/api/mrt_admin/line", {
      name: model.name,
      linecolor: model.linecolor,
      colorcode: model.colorcode,
    })
    .then(function (response) {
      message.success("新增成功");
      console.log(response);
      showNewLine.value = false;
      reloadLine();
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
  showNewLine.value = false;
}

function EditLine(id: number) {
  router.push("/linelist/" + (id as unknown as string));
}
function DeleteLine() {
  //axios delete
  axios
    .delete(
      "http://localhost:3000/api/mrt_admin/line/" +
        (selectID as unknown as string)
    )
    .then(function (response) {
      console.log(response);
      reloadLine();
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}

function openDelete(id: number) {
  showDelete.value = true;
  selectID.value = id;
}

function goback() {
  router.push("/profile");
}
</script>

<style scoped>
::-webkit-scrollbar {
  display: none;
}
</style>
