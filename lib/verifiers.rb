module SprinkleStack
  module Verifiers
    module File
      def file_contains_not(path, text)
        @commands << "grep -v '#{text}' #{path}"
      end
    end
    
    module Daemon
      def has_daemon(name)
        @commands << "test -f /etc/init.d/#{name}"
      end
    end
    
    module Logrotation
      def has_logrotation(name)
        @commands << "test -f /etc/logrotate.d/#{name}"
      end
    end
    
    module Permisson
      def has_permission(path, mod)
        @commands << "stat #{path} | grep 'Access: (#{mod}'"
      end
      
      def has_owner(name)
        @commands << "" # TODO
      end
      
      def has_group(name)
        @commands << "" # TODO
      end
    end
  end
end

Sprinkle::Verify.register(SprinkleStack::Verifiers::File)
Sprinkle::Verify.register(SprinkleStack::Verifiers::Daemon)
Sprinkle::Verify.register(SprinkleStack::Verifiers::Logrotation)
#Sprinkle::Verify.register(SprinkleStack::Verifiers::Permission)
