<template>
  <div class="form-astro-gps columns">
    <div class="column">
      <b-field label="Recherche">
        <b-switch v-model="swAutoComplete" />
      </b-field>
    </div>
    <div class="column">
      <b-field :label="!swTransit ? 'Latitude' : 'Latitude de transit'">
        <b-input
          icon="compass"
          v-if="!swAutoComplete"
          v-model="lat"
          :placeholder="
            !swTransit
              ? 'Votre latitude de naissance'
              : 'Votre latitude de transit'
          "
          @input="onChangeLat"
        >
        </b-input>
        <b-input
          icon="compass"
          v-if="swAutoComplete"
          v-model="lat"
          :placeholder="
            !swTransit
              ? 'Votre latitude de naissance'
              : 'Votre latitude de transit'
          "
          disabled
        >
        </b-input>
      </b-field>
    </div>
    <div class="column">
      <b-field :label="!swTransit ? 'Longitude' : 'Longitude de transit'">
        <b-input
          icon="compass"
          v-if="!swAutoComplete"
          v-model="lng"
          :placeholder="
            !swTransit
              ? 'Votre longitude de naissance'
              : 'Votre longitude de transit'
          "
          @input="onChangeLng"
        >
        </b-input>
        <b-input
          icon="compass"
          size="is-small"
          v-if="swAutoComplete"
          v-model="lng"
          :placeholder="
            !swTransit
              ? 'Votre longitude de naissance'
              : 'Votre longitude de transit'
          "
          disabled
        >
        </b-input>
      </b-field>
    </div>
    <div class="column">
      <b-field :label="!swTransit ? 'Zone' : 'Zone lors du transit'">
        <b-select
          icon="compass"
          v-model="offset"
          :placeholder="
            !swTransit
              ? 'Votre décalage horaire de naissance'
              : 'Votre décalage horaire lors du transit'
          "
        >
          <option
            v-for="option in listTimeZone"
            :value="option.d03_text"
            :key="option.d03_id"
          >
            {{ option.d03_text }}
          </option>
        </b-select>
      </b-field>
    </div>
    <div class="column" v-if="swAutoComplete">
      <b-field label="Recherche">
        <b-autocomplete
          icon="search"
          v-model="name"
          :placeholder="
            !swTransit ? 'Votre ville de naissance' : 'Votre ville de transit'
          "
          :field="!swTransit ? 'Ville de naissance' : 'Ville de transit'"
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

export interface D03TimeZoneInfo {
  d03_id: string;
  d03_offset: number;
  d03_text: string;
}

@Component({})
export default class InputData extends Vue {
  @Prop() private api!: string;
  @Prop() private swTransit!: boolean;
  public swAutoComplete = false;
  public list: FilterCity[] = [];
  public selected: FilterCity = { country: "", name: "", lat: 0, lng: 0 };
  public listTimeZone: D03TimeZoneInfo[] = [];
  public isFetching = false;
  public lat = 46.20222;
  public lng = 6.14569;
  public name = "";
  public offset = 1.0;

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

  private created() {
    axios
      .get(this.api + "filter-city-time-zone")
      .then(res => {
        this.listTimeZone = res.data;
      })
      .catch(error => {
        this.listTimeZone = [];
        throw error;
      });
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
      "Content-Type": "application/x-www-form-urlencoded,charset=utf-8"
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
