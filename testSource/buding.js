require('UIColor,UIButton,UIScreen');
defineClass('ViewController', {
            viewDidAppear: function(animated) {
            self.super().viewDidAppear(animated);
            },
            viewDidLoad: function() {
            self.super().viewDidLoad();
            self.setupUI();
            },
            
            clickedEnter: function(btn) {
            var vc = require('SXViewController').alloc().init();
            self.presentViewController_animated_completion(vc, YES, null);
            },

            setupUI: function(){
            self.view().setBackgroundColor(UIColor.colorWithRed_green_blue_alpha(121 / 255.0, 201 / 255.0, 111/ 255.0, 1));
            
            var btn = UIButton.alloc().init();
            btn.setTitle_forState("enter", 0);
            btn.setTitleColor_forState(UIColor.redColor(), 0);
            btn.setFrame({x:100,y:200,width:80,height:40});
            self.view().addSubview(btn);
            btn.addTarget_action_forControlEvents(self, "clickedEnter:", 64);

            }
            
            
});
