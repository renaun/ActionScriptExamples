/*
Copyright 2012-2013 Renaun Erickson

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

@author Renaun Erickson / renaun.com / @renaun
*/

package
{
import flash.display.Sprite;
import flash.utils.setTimeout;

public class ScoutMemory extends Sprite
{
	public function ScoutMemory()
	{
		setTimeout(createObjects, 1000);
	}
	
	private var keepReferencePool:Vector.<Object> = new Vector.<Object>();
	private var pool:Vector.<Object>;
	private var loops:int = 0;
	
	private function createObjects():void
	{
		loops++;
		pool = new Vector.<Object>();
		var count:int = 10000;
		for (var i:int = 0; i < count; i++) 
		{
			var o:Object = new Object();
			if (i % 5 == 0)
				keepReferencePool.push(o);
			pool.push(o);
		}
		setTimeout(removeObjects, 1000);
	}
	
	private function removeObjects():void
	{
		pool = null;
		if (loops < 2)
		setTimeout(createObjects, 1000);
	}
}
}