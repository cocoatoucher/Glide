<p align="center">
    <img src="glide_logo_transparent.png" width="128" max-width="80%" alt="Glide"/>
</p>

# glide engine components:

## Core components

##### - Transform Component
Component that defines the position and direction properties of an entity via rendering a container node on the scene for its entity's other nodes.

##### - SpriteNode Component
Component that renders a sprite node as a child of its entity's transform node.

##### - TileMapNode Component
Component that renders a tile map node as a child of its entity's transform node.

##### - LabelNode Component
Component that renders a label node as a child of its entity's transform node.

##### - KinematicsBody Component
Component that controls the entity's velocity and its transform's translation based on that velocity.

##### - Collider Component
Component that handles the collisions and controls the collider box of an entity.

##### - ColliderTileHolder Component
Component that is used to establish collisions with the collider tile map of the entity's scene.

##### - Snapper Component
Component that is used to establish collisions with snappable objects like platforms and ladders. Snapping is a special behavior which helps with partially establishing collisions between moving objects.

##### - TextureAnimator Component
Component that is used to play texture animation actions on the entity's sprite node. Uses `SKAction`s for the actual animations and uses predefined trigger ids to switch between playing animations.

## Movement related components

##### - HorizontalMovement Component
Component that is used to move its entity's kinematics body in the horizontal axis with the given movement style.

##### - VerticalMovement Component
Component that is used to move its entity's kinematics body in the vertical axis with the given movement style.

##### - CircularMovement Component
Component that is used to move its entity's kinematics body in both axes in a circular manner.

##### - OscillatingMovement Component
Component that is used to move its entity with a simple harmonic motion. Manipulates the transform position directly rather than changing the kinematics body.

##### - LerpingMovement Component
Component that is used to move its entity via interpolating the distance between entity's current position and a given target position. This movement component manipulates the transform position directly.

##### - ApproachingMovement Component
Component that is used to move its entity by `CGPoint.approach(destination:maximumDelta:)`. This movement component manipulates the transform position directly.

## Ability components

##### - PlayableCharacter Component
Coordinates the transfer of input profile values to different ability components based on given player index.

##### - Jump Component
Component that makes an entity gain a momentary vertical speed while on ground.

##### - WallClinger Component
Component that makes an entity be effected by a lower gravity and have a lower vertical speed while contacting collision collider tiles which support wall jumping.

##### - WallJump Component
Component that makes an entity gain horizontal and vertical velocity from collision collider tiles which support wall jumping.

##### - Paraglider Component
Component that makes an entity be affected by a lower gravity while it is falling down on air.

##### - JetpackOperator Component
Component that makes an entity be able to gain positive vertical speed while on air.

##### - Dasher Component
Component that makes an entity gain extra horizontal speed which will last until taking a given distance.

##### - ProjectileShooter Component
Component that makes an entity be able to shoot projectile entities with the given entity template.

##### - Health Component
Component that gives an entity health and life properties, e.g. number of lives. This also gives ability to get damaged and die.

##### - Health Component
Component that gives an entity health and life properties, e.g. number of lives. This also gives ability to get damaged and die.

##### - UpwardsLooker Component
Component that gives an entity the ability to adjust the camera to focus it above the entity's node, if camera is already focused on this entity's transform.

##### - Croucher Component
Component that gives an entity the ability to ignore one way grounds while its entity is above them and pass through below the ground. This component is also used by `PlayableCharacterComponent` which makes it possible to react to crouching via assigning a custom texture animation.

##### - Blinker Component
Component that gives an entity's rendered nodes the ability to visually blink. This is a common behavior that might come handy to indicate damage to an entity after it gets a hit. An entity's `HealthComponent`, if there is any, automatically triggers blinking for this component when an entity takes damage.

##### - Bouncer Component
Component that gives an entity the ability to gain speed in the given directions so that it bounces. Useful for post enemy/hazard contacts.

##### - Talker Component
Component that gives an entity the ability to keep a reference for being in a conversation.

##### - LadderClimber Component
Component that gives an entity the ability to interact with ladders.

##### - SwingHolder Component
Component that gives an entity the ability to interact with swings.

##### - CameraFocusAreaRecognizer Component
Component that gives an entity the ability to be trigger camera focus on specified areas. When an entity with this component establishes contact with a camera focus area, camera will automatically focus on this area.

##### - CheckpointRecognizer Component
Component that gives an entity the ability to recognize the checkpoints and save them in a list upon contact.

##### - RespawnAtCheckpointOnRestart Component
Component that gives an entity the ability to be respawned when scene restarts at its checkpoint with `checkpointId` given to this component.

##### - EntityObserver Component
Component that gives an entity the ability to observe other entities that gets into contact with specified areas in the scene, or around entity's position.

##### - Shaker Component
Component that adds an entity the ability to reposition its transform with a shake animation. Transform is reset to its original position after shake is done. It is required that transform of the entity of this component has `usesProposedPosition` set to `false`.

## Autonomous components:

##### - SelfMove Component
Component that makes an entity move on its own in the given axes and directions. Has better use cases when combined with another component like `SelfChangeDirectionComponent`.

##### - SelfChangeDirection Component
Component that makes a self moving entity change its movement direction based on preset conditions.

##### - SelfFollowWaypoints Component
Component that makes a self moving entity change its movement direction based on preset conditions.

##### - SelfShootOnObserve Component
Component that makes an entity with observing capabilities to shoot towards the closest entity among its observed entities.

##### - SelfSpawnEntities Component
Component that makes an entity spawn other provided entities either periodically with a specified time interval, or when the entity observes specified entities. Latter requires the entity to have `EntityObserverComponent`.

## Snappable components:

##### - Snappable Component
Snapping is a special behavior which helps with establishing collisions between moving objects. Add this component to your entity to make other objects with `SnapperComponent` collide with it or snap on it. Specific snapping behavior for your entity should be implemented in your custom components. For an example of this see `PlatformComponent`. An entity with Snappable component always gets updated before other custom entities.

##### - Platform Component
Component that provides snapping behaviors of a platform.

##### - Ladder Component
Component that provides snapping behaviors of a ladder.

##### - Swing Component
Component that provides snapping behaviors of a swing.

##### - BouncingPlatform Component
Component that makes an entity bounce other entities upwards that touch it from above.

##### - FallingPlatform Component
Component that makes an entity fall off via gravity after a specified time getting touched by another entity from above.

## Scene components:

##### - Camera Component
Component that controls the camera node of a scene through an entity. In a `GlideScene`, you don't need to initialize this component or a camera node as this is already done by the scene.

##### - CameraFollower Component
Component that makes an entity's transform follow the position of the camera in a scene.
It is required that transform of the entity of this component has `usesProposedPosition` set to `false`.

##### - SceneAnchoredSpriteLayout Component
Component that is used to layout its entity's sprite node with given layout constraints that can be setup related to scene dimensions. It's recommended to use this component for entities that are not a child of the scene's camera(thus, not a part of gameplay) but should render UI related nodes like text, buttons and background images.
This component makes those entities' nodes independent from camera's scaling and fixes their layout in respect to screen dimensions.

##### - InfiniteSpriteScroller Component
Component that repeats its entity's sprite node on a given axis and automatically scrolls through those repeated nodes with a given speed if desired. End result looks like sprite node of the entity is scrolling in an infinite fashion. This is useful for animating background layers of game levels to create some parallax effects.

## Environment components:

##### - LightNode Component
Component that renders a light node as a child of its entity's transform node.

##### - Checkpoint Component
Component that makes an entity behave as a checkpoint of its scene. Entities which have `CheckpointRecognizerComponent` will be able to add the checkpoint of this component to their list, when they contact with the collider of this component's entity. It is required that transform of the entity of this component has `usesProposedPosition` set to `false`.

##### - CameraFocusArea Component
Component that makes an entity trigger its scene's camera to zoom on a specified area when contacted with other entities which have `CameraFocusAreaRecognizerComponent`.

## Gameplay UI components:

##### - ConversationFlowController Component
Component that controls the flow of speech bubble entities for a given conversation in its entity's scene.

##### - SpeechFlowController Component
Component that controls the flow of text blocks and options in a single speech.

##### - FocusableEntitiesController Component
Component that keeps track of a focused entity among a group of focusable entities in a scene. This component listens for default menu input profiles to switch between focusable entities.

##### - Focusable Component
Component that makes an entity controllable by the focusables controller of a scene.

## Utility components:

##### - RemoveAfterTimeInterval Component
This component sets its entity's `canBeRemoved` to 'true' after a given period of time starting with the first time this entity.

## Component protocols:

These protocols are used by different glide components mainly to influence to behavior if their entities in different ways. You can adopt to these protocols in your custom component implementations to implement similar behavior.

##### - GlideComponent
Basic and required component protocol that should be adopted by all components for full compatibility of glide's features.

##### - StateResettingComponent
Adopted by components to prepare their states for use in the rest of their scene's update cycle. This preparation happens after the component's update methods are called. This is useful behavior for some components to interpret what has changed since the update in the last frame to the current frame and prepare this change information to be used by other elements of the scene in the same frame. `CollisionsController` of scene is an example element which gets use of such information from `ColliderComponent`s.

##### - ActionsEvaluatorComponent
When adopted, component will be informed of SKScene's `didEvaluateActions()`. Can be used by components that want to perform logic after the actions in the scene has done processing. `TextureAnimatorComponent` is an example component for this.

##### - UpdateControllingComponent
When adopted, a component can decide if its entity should be updated by the scene. Entity's `didSkipUpdate()` will be called in the next frame if at least one of its `UpdateControllingComponent`s return `false` for its `shouldEntityBeUpdated` value.

##### - DamageControllingComponent
When adopted, a component can effect its entity's damage taking capabilities.

##### - InputControllingComponent
When adopted, a component can decide if its entity's components are allowed to process inputs. `shouldBlockInputs` property of the entity should be used by each component that want to skip processing inputs.

##### - RemovalControllingComponent
When adopted, a component can decide if its entity can be removed by the scene as a result of a removal event. Entity will be removed if at least one of its `RemovalControllingComponent`s return `true` for its `canEntityBeRemoved` value. An example scenario where this might be useful is, an entity needs to be removed but there is be an explosion animation that should be played. Adoption of this protocol by the component which will play this animation ensures that the entity will not be removed until the animation has done playing.

##### - ZPositionContainerIndicatorComponent
When adopted, a component can specify which z position container its entity's transform node should use as a parent. If multiple components of an entity specify a z position container only the container specified by the component with the lowest `componentPriority` is taken into account.

##### - NodeLayoutableComponent
When adopted, layout method in this protocol is called for the component to layout its rendered nodes in respect to screen size.

##### - CameraFocusingComponent
When adopted, a component can specify an offset value from its transform's position when the camera of the scene is focused on that transform.

##### - RespawnableEntityComponent
When adopted, a component can specify an offset value from its transform's position when the camera of the scene is focused on that transform.

##### - DebuggableComponent
When adopted, an entity can manage its debug elements(e.g. debug nodes) in a more structured way. Note that functionality related to this component is only enabled if `DEBUG` flag is on during compile time.
