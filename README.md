# SpriteKitBugTester

There is an iOS 9 bug in Sprite Kit.

When you add a node inside a block, the parent is nil and touches are no longer transferred to parent nodes.

This is extremely annoying. Say you want to remove a node, add it to a different parent, and then later, you would like to add remove it from the new parent and add to the old parent. You would put this later action in a block. But it won't work in iOS nine.

This will detect that bug.

It will not fix that bug, but you can at least know when it is present and work around it.

Instructions:

Add this project to your workspace and build it.
