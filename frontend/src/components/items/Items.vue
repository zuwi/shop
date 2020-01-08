<template>
  <div class="max-w-md m-auto py-10">
    <div class="text-red" v-if="error">{{ error }}</div>
    <h3 class="font-mono font-regular text-3xl mb-4">Add a new item</h3>
    <form action="" @submit.prevent="addItem">
      <div class="mb-6">
        <input class="input"
               autofocus autocomplete="off"
               placeholder="Type an item name"
               v-model="newItem.name" />
      </div>
      <div class="mb-6">
        <input class="input"
               autofocus autocomplete="off"
               placeholder="Type an item description"
               v-model="newItem.description" />
      </div>
      <div class="mb-6">
        <input type="date"
               placeholder="Select Release Date"
               v-model="newItem.release_date" />
      </div>
      <div class="mb-6">
        <input type="time"
               placeholder="Select Release Time"
               v-model="newItem.release_time" />
      </div>
      <div class="mb-6">
        <select id="brand" class="select" v-model="newItem.brand">
          <option disabled value="">
            Select a brand
          </option>
          <option v-for="brand in brands" :value="brand.id" :key="brand.id">
            {{ brand.name }}
          </option>
        </select>
        <p class="pt-4">
          Don't see a brand?
          <router-link to="/brands" class="text-indigo-400">Create one</router-link>
        </p>
      </div>
      <input type="submit" value="Add Item" class="cursor-pointer no-underline block w-full py-4 items-center justify-center btn btn-blue" />
    </form>

    <hr class="border border-grey-light my-6" />

    <ul class="list-reset mt-4">
      <li class="py-4" v-for="item in items" :key="item.id" :item="item">

        <div class="flex items-center justify-between flex-wrap">
          <p class="block flex-1 font-mono font-semibold flex items-center ">
            <svg class="fill-current text-indigo w-6 h-6 mr-2" viewBox="0 0 20 20" width="20" height="20"><title>item</title><path d="M15.75 8l-3.74-3.75a3.99 3.99 0 0 1 6.82-3.08A4 4 0 0 1 15.75 8zm-13.9 7.3l9.2-9.19 2.83 2.83-9.2 9.2-2.82-2.84zm-1.4 2.83l2.11-2.12 1.42 1.42-2.12 2.12-1.42-1.42zM10 15l2-2v7h-2v-5z"></path></svg>
            {{ item.name }} <br>
            {{ item.release_date }} <br>
            {{ item.description }}
          </p>
          <p class="block font-mono font-semibold">
            {{ getBrand(item) }}
          </p>

          <button class="bg-tranparent text-sm hover:bg-blue hover:text-white text-blue border border-blue no-underline font-bold py-2 px-4 mr-2 rounded"
                  @click.prevent="editItem(item)">Edit</button>

          <button class="bg-transprent text-sm hover:bg-red text-red hover:text-white no-underline font-bold py-2 px-4 rounded border border-red"
                  @click.prevent="removeItem(item)">Delete</button>
        </div>

        <div v-if="item == editedItem">
          <form action="" @submit.prevent="updateItem(item)">
            <div class="mb-6 p-4 bg-white rounded border border-grey-light mt-4">
              <div class="mb-6">
                <input class="input" v-model="item.name" />
              </div>
              <div class="mb-6">
                <input class="input" v-model="item.release_date" />
              </div>
              <div class="mb-6">
                <input class="input" v-model="item.release_time" />
              </div>
              <div class="mb-6">
                <input class="input" v-model="item.description" />
              </div>
              <div class="mb-6">
                <select id="brand_update" class="select" v-model="item.brand">
                  <option disabled value="">
                    Select a brand
                  </option>
                  <option v-for="brand in brands" :value="brand.id" :key="brand.id">
                    {{ brand.name }}
                  </option>
                </select>
              </div>
              <div>
                <button @click.prevent="cancelEdit(item)" type="button" class="my-2 cursor-pointer border-transparent border-4 text-indigo-400 hover:text-indigo-900">
                  Cancel
                </button>
                <input type="submit" value="Update" class=" my-2 text-sm cursor-pointer btn btn-blue">
              </div>
            </div>
          </form>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'Items',
  data () {
    return {
      items: [],
      brands: [],
      newItem: [],
      error: '',
      editedItem: ''
    }
  },
  created () {
    if (!localStorage.loggedIn) {
      this.$router.replace('/')
    } else {
      // set items
      this.$http.secured.get('/api/v1/items')
        .then(response => { this.items = response.data })
        .catch(error => this.setError(error, 'Something went wrong'))

      // set brands
      this.$http.secured.get('/api/v1/brands')
        .then(response => { this.brands = response.data })
        .catch(error => this.setError(error, 'Something went wrong'))
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    getBrand (item) {
      const itemBrandValues = this.brands.filter(brand => brand.id === item.brand_id)
      let brand

      itemBrandValues.forEach(function (element) {
        brand = element.name
      })

      return brand
    },
    addItem () {
      const value = this.newItem
      if (!value) {
        return
      }
      this.$http.secured.post('/api/v1/items/', { item: {
        name: this.newItem.name,
        description: this.newItem.description,
        release_date: this.newItem.release_date,
        release_time: this.newItem.release_time,
        brand_id: this.newItem.brand } })
        .then(response => {
          this.items.push(response.data)
          this.newItem = ''
        })
        .catch(error => this.setError(error, 'Cannot create item'))
    },
    removeItem (item) {
      this.$http.secured.delete(`/api/v1/items/${item.id}`)
        .then(response => {
          this.items.splice(this.items.indexOf(item), 1)
        })
        .catch(error => this.setError(error, 'Cannot delete item'))
    },
    editItem (item) {
      this.cachedItem = Object.assign({}, item)
      this.editedItem = item
    },
    updateItem (item) {
      this.editedItem = ''
      this.$http.secured.patch(`/api/v1/items/${item.id}`, { item: { name: item.name } })
        .catch(error => this.setError(error, 'Cannot update item'))
    },
    cancelEdit (item) {
      this.editedItem = ''
      Object.assign(item, this.cachedItem)
    }
  }
}
</script>
