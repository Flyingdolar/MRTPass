import { createRouter, createWebHashHistory, RouteRecordRaw } from "vue-router";
import HomeView from "../views/HomeView.vue";

const routes: Array<RouteRecordRaw> = [
  {
    path: "/",
    name: "home",
    component: HomeView,
    children: [
      {
        path: "MRTInfo",
        name: "MRTInfo",
        component: () => import("../views/MRTInfo.vue"),
      },
      {
        path: "MRTAnnounce",
        name: "MRTAnnounce",
        component: () => import("../views/MRTAnnounce.vue"),
      },
    ],
  },
  {
    path: "/about",
    name: "about",
    component: () => import("../views/AboutView.vue"),
  },
  {
    path: "/post",
    name: "viewpost",
    component: () => import("../views/submitPost.vue"),
  },
  {
    path: "/account",
    name: "myaccount",
    component: () => import("../views/account/MyAccount.vue"),
  },
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

export default router;
