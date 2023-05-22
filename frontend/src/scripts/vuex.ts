import { createStore } from "vuex";
import type { LoginInfo } from "./types";

export interface State {
  userinfo: LoginInfo | undefined;
}

const store = createStore<State>({
  state: {
    userinfo: undefined,
  },
  getters: {
    userinfo: (state) => {
      return state.userinfo;
    },
  },
  actions: {
    userinfo(ctx, userinfo) {
      ctx.commit("userinfo", userinfo);
    },
  },
  mutations: {
    async userinfo(state, userinfo) {
      state.userinfo = userinfo;
    },
  },
});

export default store;
