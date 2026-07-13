package com.explapp.badrlegacy;

import org.junit.Test;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import static org.junit.Assert.*;

public class BadrDataTest {
    @Test public void allLearningIdsAreUniqueAndComplete() {
        List<BadrData.Item> all=BadrData.allItems();
        assertEquals(51,all.size());
        Set<String> ids=new HashSet<String>();
        for(BadrData.Item item:all){
            assertTrue(ids.add(item.id));
            assertNotNull(item.ar);
            assertFalse(item.ar.trim().isEmpty());
            assertNotNull(item.en);
            assertFalse(item.en.trim().isEmpty());
            assertNotNull(item.hint);
        }
    }

    @Test public void everyWorldHasEnoughOfflineContent() {
        assertEquals(6,BadrData.WORLDS.size());
        for(BadrData.World world:BadrData.WORLDS){
            assertTrue(world.items.size()>=8);
            for(BadrData.Item item:world.items)assertEquals(world.id,item.world);
        }
        assertEquals(11,BadrData.WORLDS.get(4).items.size());
    }

    @Test public void storiesHaveCompletePageSequences() {
        assertEquals(6,BadrData.STORIES.size());
        for(BadrData.Story story:BadrData.STORIES){
            assertEquals(4,story.pages.length);
            for(String page:story.pages)assertTrue(page.length()>10);
        }
    }
}
