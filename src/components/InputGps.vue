<template>
  <div class="form-astro-gps columns">
    <div class="column">
      <b-field label="Mode de saisie manuel/recherche">
        <b-switch v-model="swAutoComplete" />
      </b-field>
    </div>
    <div class="column">
      <b-field label="Latitude">
        <b-input
          placeholder="Votre latitude de naissance"
          icon="compass"
          size="is-medium"
          v-if="!swAutoComplete"
          v-model="lat"
          @input="onChangeLat"
        >
        </b-input>
        <b-input
          placeholder="Votre latitude de naissance"
          icon="compass"
          size="is-medium"
          v-if="swAutoComplete"
          v-model="lat"
          disabled
        >
        </b-input>
      </b-field>
    </div>
    <div class="column">
      <b-field label="Longitude">
        <b-input
          placeholder="Votre longitude de naissance"
          icon="compass"
          size="is-medium"
          v-if="!swAutoComplete"
          v-model="lng"
          @input="onChangeLng"
        >
        </b-input>
        <b-input
          placeholder="Votre longitude de naissance"
          icon="compass"
          size="is-medium"
          v-if="swAutoComplete"
          v-model="lng"
          disabled
        >
        </b-input>
      </b-field>
    </div>
    <div class="column" v-if="swAutoComplete">
      <b-field label="Recherche">
        <b-autocomplete
          placeholder="Votre lieu de naissance"
          field="Ville de naissance"
          icon="search"
          size="is-medium"
          v-model="name"
          :data="list"
          :loading="isFetching"
          @typing="getAsyncData"
          @input="onChangeSearch"
          @select="option => (selected = option)"
        >
          <template slot-scope="props">
            <div class="media">
              <div class="media-left">
                <img :src="getFlag(props.option.country.toLowerCase())" />
              </div>
              <div class="media-content">
                {{ props.option.name }}
                <br />
                <small
                  >Lat: {{ props.option.lat }} Lng:
                  {{ props.option.lng }}</small
                >
              </div>
            </div>
          </template>
        </b-autocomplete>
      </b-field>
    </div>
  </div>
</template>
<script lang="ts">
import { Component, Prop, Watch, Vue } from "vue-property-decorator";
//import debounce from "loadash/debounce";
import { Debounce } from "vue-debounce-decorator";

const axios = require("axios").default;

export interface FilterCity {
  country: string;
  name: string;
  lat: number;
  lng: number;
}

@Component({})
export default class InputData extends Vue {
  @Prop() private api!: string;
  public swAutoComplete = false;
  public list: FilterCity[] = [];
  public selected: FilterCity = { country: "", name: "", lat: 0, lng: 0 };
  public isFetching = false;
  public lat = 46.0222;
  public lng = 6.14569;
  public name = "";

  public getFlag(country) {
    return require("../assets/" + country + ".png");
  }

  public onChangeSearch() {
    if (this.name == "") {
      this.selected = { country: "", name: "", lat: 0, lng: 0 };
    }
    if (this.selected.name !== "") {
      this.lat = this.selected.lat;
      this.lng = this.selected.lng;
      this.onChange();
    }
  }

  public onChangeLat(lat) {
    this.lat = lat;
    this.onChange();
  }

  public onChangeLng(lng) {
    this.lng = lng;
    this.onChange();
  }

  public onChange() {
    this.$emit("change-lat-lng", { lat: this.lat, lng: this.lng });
  }

  //@Watch("getAsyncData")
  @Debounce(500)
  public async getAsyncData(name) {
    if (!name.length) {
      this.list = [];
      return;
    }
    this.isFetching = true;
    const config = {
      "Content-Type": "application/x-www-form-urlencoded"
    };
    axios
      .get(this.api + "filter-city/" + name, config)
      .then(res => {
        this.list = res.data;
        //this.$forceUpdate();
      })
      .catch(error => {
        this.list = [];
        throw error;
      })
      .finally(() => {
        this.isFetching = false;
      });
  }
}
</script>
<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.form-astro-gps {
  margin: 20px;
}
</style>
