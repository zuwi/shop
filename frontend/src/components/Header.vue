<template>
  <header class="bg-grey-lighter py-4">
    <div class="container m-auto flex flex-wrap items-center justify-end">
      <div class="flex-1 flex items-center">
        <a href="/" class="uppercase text-sm font-mono pl-4 font-semibold no-underline text-indigo-dark hover:text-indigo-darker">Shop</a>
      </div>
      <div>
        <router-link to="/" class="link-grey px-2 no-underline" v-if="!loggedIn()">Login</router-link>
        <router-link to="/registration" class="link-grey px-2 no-underline" v-if="!loggedIn()">Registration</router-link>
        <router-link to="/items" class="link-grey px-2 no-underline" v-if="loggedIn()">Items</router-link>
        <a href="#" @click.prevent="logout" class="link-grey px-2 no-underline" v-if="loggedIn()">Logout</a>
      </div>
    </div>
  </header>
</template>

<script>
export default {
  name: 'Header',
  created () {
    this.loggedIn()
  },
  methods: {
    setError (error, message) {
      this.error = (error.response && error.response.data && error.response.data.error) || message
    },
    loggedIn () {
      return localStorage.loggedIn
    },
    logout () {
      this.$http.secured.delete('/login')
        .then(response => {
          delete localStorage.csrf
          delete localStorage.loggedIn
          this.$router.replace('/')
        })
        .catch(error => this.setError(error, 'Cannot logout'))
    }
  }
}
</script>
