<template>
  <div flex="~ col" justify="center items-end" h="10" bg="white">
    <div flex="~" m="t-auto b-10px l-6 r-17" justify="items-center">
      <n-button @click="goback" quaternary>
        <n-icon :size="20"><back /></n-icon>
      </n-button>
      <div
        flex="grow"
        mt="1"
        text="title center bottom"
        style="font-size: 16px"
      >
        捷運站點編輯
      </div>
    </div>
  </div>
  <!-- 頁面選項 Tab -->
  <n-tabs
    default-value="info"
    justify-content="space-evenly"
    type="line"
    z-index="1000"
    bg="white"
  >
    <n-tab name="info" @click="selectTab = '基本資訊'">基本資訊 </n-tab>
    <n-tab name="announce" @click="selectTab = '班次列表'">班次列表 </n-tab>
  </n-tabs>
  <div
    v-show="selectTab == '基本資訊'"
    flex="~ col gap-3"
    h="149"
    overflow="auto"
    w="full"
  >
    <div p="2px" />
    <n-card title="站點路線" role="dialog" aria-modal="true">
      <n-form ref="formRef" :label-width="80">
        <n-form-item label="站點名稱"
          ><n-input v-model:value="model.name"></n-input
        ></n-form-item>
        <n-form-item label="所屬路線"
          ><n-select
            v-model:value="model.linecolor"
            :options="lineOptions"
          ></n-select
        ></n-form-item>
        <n-form-item label="所屬路線編號"
          ><n-input v-model:value="model.number"></n-input
        ></n-form-item>
      </n-form>
    </n-card>
    <n-card title="交叉資訊" role="dialog" aria-modal="true">
      <n-form ref="formRef" :label-width="80">
        <n-form-item label="交叉路線"
          ><n-select
            v-model:value="model.linecolor2"
            :options="lineOptions"
          ></n-select
        ></n-form-item>
        <n-form-item label="交叉路線編號"
          ><n-input v-model:value="model.number2"></n-input
        ></n-form-item>
      </n-form>
    </n-card>
    <n-card title="地理位置" role="dialog" aria-modal="true">
      <n-form ref="formRef" :label-width="80">
        <n-form-item label="經度"
          ><n-input v-model:value="model.y_Pos"></n-input
        ></n-form-item>
        <n-form-item label="緯度"
          ><n-input v-model:value="model.x_Pos"></n-input
        ></n-form-item>
        <n-form-item label="站點出口數"
          ><n-input v-model:value="model.exit_Num"></n-input
        ></n-form-item>
      </n-form>
    </n-card>
    <div p="8" />
  </div>
  <div v-show="selectTab == '班次列表'" flex="~" bg="gray-50" p="x-6 y-1">
    <n-button
      @click="currentindex -= 20"
      :disabled="checkminvalue()"
      type="info"
      quaternary
    >
      <template #icon>
        <n-icon :size="18"><back /></n-icon>
      </template>
      <div>上一頁</div>
    </n-button>
    <div flex="grow" />
    <n-button
      @click="currentindex += 20"
      :disabled="checkmaxvalue()"
      icon-placement="right"
      type="info"
      quaternary
    >
      <div>下一頁</div>
      <template #icon>
        <n-icon :size="18"><next /></n-icon>
      </template>
    </n-button>
  </div>
  <div
    v-show="selectTab == '班次列表'"
    flex="~ col gap-3"
    h="139"
    overflow="auto"
    w="full"
  >
    <n-card
      v-for="(item, index) in filteredItems(currentindex)"
      :key="item.timetable.id"
    >
      <div flex="~">
        <div flex="grow" text="lg title" space="y-2">
          <div flex="~ gap-2" justify="items-center" text="xs">
            <div p="x-2 y-0.5" border="1 rounded-lg">
              {{ item.line }}
            </div>
            <div text="secondary" my="auto">往{{ item.to }}</div>
          </div>
          <div flex="~ gap-4" justify="items-end" m="l-2">
            <div>班次{{ item.timetable.No.toString() }}</div>
            <div flex="~ gap-1" justify="items-center">
              <n-icon size="16" my="auto"><iTime text="title" /></n-icon>
              <div text="sm" my="auto">{{ item.timetable.time }}</div>
            </div>
          </div>
        </div>
        <div flex="~ gap-3">
          <n-button quaternary @click="EditTimeTable(item.timetable)" my="auto">
            <template #icon>
              <n-icon><edit /></n-icon>
            </template>
          </n-button>
          <n-button
            quaternary
            my="auto"
            @click="openDelete(item.timetable.id, index)"
          >
            <template #icon>
              <n-icon text="danger"><remove /></n-icon>
            </template>
          </n-button>
        </div>
      </div>
    </n-card>
  </div>
  <!-- Footer -->
  <n-card
    v-show="selectTab == '基本資訊'"
    pos="fixed bottom-16"
    footer-style="padding: 0px;"
    :hoverable="true"
  >
    <template #footer>
      <div class="flex justify-center py-4 px-12">
        <n-button flex="~ grow" type="success" ghost @click="SaveEdit">
          <template #icon>
            <n-icon :size="18"><save /></n-icon>
          </template>
          儲存
        </n-button>
      </div>
    </template>
  </n-card>

  <!-- Overlay: Edit -->
  <n-modal v-model:show="editTimeTablemodal">
    <n-card
      title="編輯班次"
      :header-style="{ 'align-self': 'center' }"
      :bordered="false"
      role="dialog"
      aria-modal="true"
    >
      <n-form ref="formRef">
        <n-form-item label="所屬路線"
          ><n-select
            v-model:value="CurrentRoute"
            :options="lineOptions2"
          ></n-select
        ></n-form-item>
        <n-form-item label="班次目的地"
          ><n-select
            v-model:value="CurrentStation"
            :options="stationOpt"
            placeholder="請選擇站點"
        /></n-form-item>
        <n-form-item label="車次"
          ><n-input v-model:value="model.Mrtno"></n-input
        ></n-form-item>
        <n-form-item label="到站時間">
          <n-time-picker
            v-model:formatted-value="model.deptime"
            value-format="H~m~s"
            :actions="['confirm']"
          />
        </n-form-item>
      </n-form>
      <template #footer>
        <div class="flex justify-center py-4 px-20">
          <n-button
            flex="~ grow"
            type="success"
            ghost
            @click="SaveTimeTableEdit"
          >
            <template #icon>
              <n-icon :size="18"><save /></n-icon>
            </template>
            暫存
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
          <n-button type="error" flex="grow" ghost @click="DeleteStation">
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
  NSpace,
  NButton,
  NModal,
  NDataTable,
  useMessage,
  NH3,
  NForm,
  NIcon,
  NFormItem,
  NInput,
  NSelect,
  NPopconfirm,
  NTab,
  NTabs,
  NTabPane,
  NTimePicker,
} from "naive-ui";
import back from "../assets/icon/iExpLeft.vue";
import next from "../assets/icon/iExpRight.vue";
import save from "../assets/icon/iSave.vue";
import edit from "../assets/icon/iEdit.vue";
import remove from "../assets/icon/iTrash.vue";
import cancel from "../assets/icon/iRefund.vue";
import iTime from "../assets/icon/iTime.vue";
import type { DataTableColumns } from "naive-ui";
import {
  computed,
  h,
  onMounted,
  ref,
  watch,
  reactive,
  onBeforeMount,
} from "vue";
import { watchOnce } from "@vueuse/core";
import {
  Station,
  Role,
  Line,
  TimeTable,
  AlotsTimeTable,
  LineStation,
} from "../scripts/types";
import axios from "axios";
import router from "@/router";
import { useRoute } from "vue-router";
const selectTab = ref("基本資訊");
const message = useMessage();
const editTimeTablemodal = ref(false);
const showDelete = ref(false);
const route = useRoute();
const model = reactive({
  exit_Num: 0,
  id: 0,
  name: "",
  x_Pos: 0,
  y_Pos: 0,
  number: 0,
  linecolor: "",
  linename: "",
  number2: "",
  linecolor2: "",
  linename2: "",
  deptime: ref("0~0~0"),
  Mrtno: "",
});
const AllLine = ref<Line[]>();
const AllLine2 = ref<Line[]>();
const AllTimeTable = ref<AlotsTimeTable[]>();
const currentId = ref(0);
const currentindex = ref(0);
onBeforeMount(() => {
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/station/" + route.params.id)
    .then(function (response) {
      //message.info(response.data.message);
      //console.log(response.data.data);
      //console.log(response.data.data.stationno);
      model.exit_Num = response.data.data.station.exit_Num;
      model.id = response.data.data.station.id;
      model.name = response.data.data.station.name;
      model.x_Pos = response.data.data.station.x_Pos;
      model.y_Pos = response.data.data.station.y_Pos;
      model.number = response.data.data.stationno[0].stationno.number;
      model.linecolor = response.data.data.stationno[0].stationno.linecolor;
      model.linename = response.data.data.stationno[0].linename;
      if (response.data.data.stationno.length == 2) {
        model.number2 = response.data.data.stationno[1].stationno.number;
        model.linecolor2 = response.data.data.stationno[1].stationno.linecolor;
        model.linename2 = response.data.data.stationno[1].linename;
      }
      //console.log(model);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/line")
    .then(function (response) {
      //console.log(response.data.data);
      AllLine.value = response.data.data;
      //console.log(AllLine.value);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
  axios
    .get(
      "http://localhost:3000/api/mrt_admin/station/" + route.params.id + "/line"
    )
    .then(function (response) {
      //console.log(response.data.data);
      AllLine2.value = response.data.data;
      //console.log(AllLine.value);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
  //axios get
  axios
    .get(
      "http://localhost:3000/api/mrt_admin/station/" +
        route.params.id +
        "/time_table"
    )
    .then(function (response) {
      // console.log(response.data.data);
      AllTimeTable.value = response.data.data;
      //console.log("done");
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
});
const lineOptions = computed(() =>
  AllLine.value?.map((v, index) => ({
    label: v.linecolor + v.name,
    value: v.linecolor,
  }))
);
const lineOptions2 = computed(() =>
  AllLine2.value?.map((v, index) => ({
    label: v.linecolor + v.name,
    value: v.linecolor,
  }))
);
function goback() {
  router.push("/stationlist");
}
function SaveEdit() {
  //axios patch
  axios
    .patch("http://localhost:3000/api/mrt_admin/station/" + route.params.id, {
      name: model.name,
      linecolor_1: model.linecolor,
      number_1: model.number,
      x_Pos: model.x_Pos,
      y_Pos: model.y_Pos,
      linecolor_2: model.linecolor2,
      number_2: model.number2,
      exit_Num: model.exit_Num,
    })
    .then(function (response) {
      message.success("修改成功");
      router.push(0);
    })
    .catch(function (error) {
      message.error("修改失敗");
    });
  //axios
}

function openDelete(id: number, index: number) {
  showDelete.value = true;
  currentId.value = id;
  currentindex.value = index;
}

function DeleteStation() {
  //axios delete
  axios
    .delete(
      "http://localhost:3000/api/mrt_admin/station/" +
        route.params.id +
        "/time_table/" +
        (currentId.value as unknown as string)
    )
    .then(function (response) {
      message.success("刪除成功");
      AllTimeTable.value?.splice(currentindex.value, 1);
      router.push(0);
    })
    .catch(function (error) {
      message.error("刪除失敗");
    });
  //axios
}
const editing = ref(0);
function EditTimeTable(item: TimeTable) {
  editTimeTablemodal.value = !editTimeTablemodal.value;
  model.Mrtno = item.No.toString();
  CurrentRoute.value = item.line;
  editing.value = item.id;
}
function filteredItems(index: number) {
  const retItems = AllTimeTable.value?.slice(index, index + 20);
  return retItems;
}
function checkmaxvalue() {
  if (currentindex.value + 20 < AllTimeTable.value?.length) {
    return false;
  } else {
    return true;
  }
}
function checkminvalue() {
  if (currentindex.value == 0) {
    return true;
  } else {
    return false;
  }
}
function formatNumber(number: number) {
  return number < 10 ? "0" + number : number.toString();
}
function SaveTimeTableEdit() {
  console.log(CurrentStation.value);
  //console.log(model.deptime.split("~")[0] + ":" + model.deptime.split("~")[1]);
  const depH = computed(() => {
    const number = parseInt(model.deptime.split("~")[0]);
    return formatNumber(number);
  });
  const depM = computed(() => {
    const number = parseInt(model.deptime.split("~")[1]);
    return formatNumber(number);
  });
  console.log(depH.value + ":" + depM.value);
  //axios patch
  axios
    .patch(
      "http://localhost:3000/api/mrt_admin/station/" +
        route.params.id +
        "/time_table/" +
        editing.value.toString(),
      {
        time: depH.value + ":" + depM.value,
        No: parseInt(model.Mrtno),
        line: CurrentRoute.value,
        end: CurrentStation.value,
      }
    )
    .then(function (response) {
      message.success("修改成功");
      editTimeTablemodal.value = false;
      router.push(0);
    })
    .catch(function (error) {
      message.error("修改失敗");
    });
  //axios
}
const CurrentLineStation = ref<LineStation[]>();
const CurrentRoute = ref<string>();
const CurrentStation = ref<number | null>();
const stationOpt = computed(() =>
  CurrentLineStation.value?.map((v, index) => ({
    label: v.station.name,
    value: v.station.id,
  }))
);
watch(CurrentRoute, (CurrentRoute) => {
  CurrentStation.value = null;
  //console.log(CurrentRoute);
  updateStationOpt();
});
function updateStationOpt() {
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/line_station", {
      params: {
        linecolor: CurrentRoute.value,
      },
    })
    .then(function (response) {
      //console.log(response);
      CurrentLineStation.value = response.data.data;
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
</script>

<style scoped>
::-webkit-scrollbar {
  display: none;
}
</style>
