import { SafeAreaView } from "react-native-safe-area-context";
import React, { useEffect } from "react";
import {
  View,
  FlatList,
  Text,
  ActivityIndicator,
  TouchableOpacity,
} from "react-native";
import { useOrganisationStore } from "@/store/useOrganisationStore";
import { useUser } from "@clerk/clerk-expo";
import { useFetch } from "@/lib/fetch";
import { DonationHistory } from "@/types/type";
import HistoryCard from "@/components/HistoryCard";

const History = () => {
  const { user } = useUser();
  const setDonationHistory = useOrganisationStore(
    (state) => state.setDonationHistory
  );

  const {
    data: response,
    loading,
    error,
    refetch,
  } = useFetch<{ data: DonationHistory[] }>(user?.id ? `/(api)/donations/${user.id}` : null);

  useEffect(() => {
    if (response && response.data) {
      setDonationHistory(response.data);
    }
    if (error) {
      console.log(error);
    }
  }, [response, error, setDonationHistory]);

  const donationdata = response?.data;

  if (loading) {
    return (
      <SafeAreaView className="h-full bg-main-primarybg">
        <ActivityIndicator size="large" />
      </SafeAreaView>
    );
  }

  if (error) {
    return (
      <SafeAreaView className="flex-1 bg-main-primarybg">
        <View className="flex-1 items-center justify-center px-5">
          <Text className="text-white text-center">Could not load donation history.</Text>
          <Text className="text-white text-center mt-2">{error}</Text>
          <TouchableOpacity onPress={refetch} className="mt-4 p-3">
            <Text className="text-emerald-400">Try again</Text>
          </TouchableOpacity>
        </View>
      </SafeAreaView>
    );
  }

  const renderItem = ({ item }: { item: DonationHistory }) => (
    <HistoryCard history={item} />
  );

  // Header component
  const headerComponent = () => (
    <>
      <View className="p-4 mt-2 mb-2">
        <Text className="text-2xl font-JakartaExtraBold text-white">
          Payment Receipts{" "}
        </Text>
      </View>
    </>
  );

  return (
    <SafeAreaView className="h-full bg-main-primarybg">
      <FlatList
        data={donationdata}
        renderItem={renderItem}
        keyExtractor={(item) => item.id.toString()}
        ListHeaderComponent={headerComponent}
        ListEmptyComponent={
          <Text className="p-4 text-center text-white font-JakartaExtraBold">
            No donations found
          </Text>
        }
        className="px-5 bg-main-primarybg mb-11 "
      />
    </SafeAreaView>
  );
};

export default History;
