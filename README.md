# React Native Cube Transition

React Native module for iOS that rotates components on a cube, similar to Instagram Stories.

![](https://media.giphy.com/media/l3vRnfQanOVb6UTQc/source.gif)

## Installation

Install the module from npm.

```bash
npm install react-native-cube-transition --save
```

### iOS

Link the framework in XCode.

* Right click _Libraries_
* Add Files to _[Your Project's Name]_
* Go to `node_modules/react-native-cube-transition/RNCubeTransition`
* Add the `.xcodeproj` file

### Android

Not supported, yet.

## Usage

```javascript
import React, { Component } from 'react';
import { Image, Dimensions, Text, StyleSheet, View } from 'react-native';
import { RNCubeTransition } from 'react-native-cube-transition';

export default class MyComponent extends Component {
  render() {
    return (
      <View style={styles.container}>
        <RNCubeTransition style={styles.page}>
          <View style={[styles.view, styles.view1]}>
            <Text style={styles.text}>3D Cube Transitions Using React Native</Text>
          </View>
          <Image
            source={require('./assets/test-1.jpg')}
            style={styles.image}
          />
          <View style={[styles.view, styles.view2]}>
            <Text style={styles.text}>Use View or Image components</Text>
          </View>
          <Image
            source={require('./assets/test-2.jpg')}
            style={styles.image}
          />
          <View style={[styles.view, styles.view2]}>
            <Text style={styles.text}>Even Gifs</Text>
          </View>
          <Image
            source={require('./assets/test-3.gif')}
            style={styles.image}
          />
        </RNCubeTransition>
      </View>
    );
  }
}

const { width, height } = Dimensions.get('window');
const styles = StyleSheet.create({
  container: {
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
    flex: 1,
  },
  page: {
    position: 'absolute',
    flexDirection: 'row',
    overflow: 'hidden',
    top: 0,
    bottom: 0,
    left: 0,
    right: 0,
  },
  image: {
    resizeMode: 'stretch',
    width,
    height,
  },
  view: {
    justifyContent: 'center',
    alignItems: 'center',
    width,
    height,
  },
  text: {
    color: '#FFF',
    textAlign: 'center',
    fontSize: 30,
  },
});
```

## License

MIT
