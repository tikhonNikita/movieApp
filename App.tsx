import React from 'react';
import {TrendingMoviesScreen} from './src/trending-movies/TrendingMoviesScreen';
import {NavigationContainer} from '@react-navigation/native';
import {createBottomTabNavigator} from '@react-navigation/bottom-tabs';
import {FavoritesScreen} from './src/favourite-movies/FavouriteMoviesScreen';
import MaterialIcons from 'react-native-vector-icons/MaterialCommunityIcons';
import {RouteProp} from '@react-navigation/native';
import {QueryClient, QueryClientProvider} from '@tanstack/react-query';
import {FavouriteMoviesProvider} from './src/favourite-movies/FavouriteMoviesContext';
import {GestureHandlerRootView} from 'react-native-gesture-handler';

const Tab = createBottomTabNavigator();

type TabBarIconProps = {
  color: string;
  size: number;
};

type ScreenOptionsProps = {
  route: RouteProp<Record<string, object | undefined>, string>;
};
const iconMap: {[key: string]: string} = {
  Home: 'home-variant-outline',
  Favorites: 'heart',
};

const getIconName = (routeName: string): string => iconMap[routeName] || '';

const getTabBarIcon =
  (route: ScreenOptionsProps['route']) =>
  ({color, size}: TabBarIconProps) => {
    const iconName = getIconName(route.name);
    return <MaterialIcons name={iconName} size={size} color={color} />;
  };

const queryClient = new QueryClient();

const App: React.FC = () => {
  return (
    <GestureHandlerRootView style={{flex: 1}}>
      <QueryClientProvider client={queryClient}>
        <FavouriteMoviesProvider>
          <NavigationContainer>
            <Tab.Navigator
              screenOptions={({route}) => ({
                tabBarIcon: getTabBarIcon(route),
                tabBarActiveTintColor: '#007aff',
                tabBarInactiveTintColor: 'gray',
              })}>
              <Tab.Screen name="Home" component={TrendingMoviesScreen} />
              <Tab.Screen name="Favorites" component={FavoritesScreen} />
            </Tab.Navigator>
          </NavigationContainer>
        </FavouriteMoviesProvider>
      </QueryClientProvider>
    </GestureHandlerRootView>
  );
};

export default App;
