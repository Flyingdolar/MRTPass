import { createStore } from "vuex";
import type { LoginInfo, User } from "./types";

export interface State {
  userinfo: LoginInfo | undefined;
  editinfo: User | undefined;
}

const store = createStore<State>({
  state: {
    userinfo: undefined,
    editinfo: undefined,
  },
  getters: {
    userinfo: (state) => {
      return state.userinfo;
    },
    editinfo: (state) => {
      return state.editinfo;
    },
  },
  actions: {
    userinfo(ctx, userinfo) {
      ctx.commit("userinfo", userinfo);
    },
    editinfo(ctx, editinfo) {
      ctx.commit("editinfo", editinfo);
    },
  },
  mutations: {
    async userinfo(state, userinfo) {
      state.userinfo = userinfo;
    },
    async editinfo(state, editinfo) {
      state.editinfo = editinfo;
    },
  },
});

export default store;
